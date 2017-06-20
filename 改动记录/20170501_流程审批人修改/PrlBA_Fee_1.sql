alter table wf_prlba_fee_app add (AppOrder int);
alter table wf_prlba_pay_app add (AppOrder int);
alter table wf_prlba_baoxiao_app add (AppOrder int);

create table wf_prlba_fee_app_1705 as select * from wf_prlba_fee_app;
create table wf_prlba_pay_app_1705 as select * from wf_prlba_pay_app;
create table wf_prlba_baoxiao_app_1705 as select * from wf_prlba_baoxiao_app;

update wf_prlba_fee_app f
   set f.apporder = decode(f.apptype,
                           0,
                           5,
                           10,
                           10,
                           20,
                           15,
                           25,
                           20,
                           26,
                           23,
                           28,
                           25,
                           30,
                           30,
                           90,
                           35,
                           40,
                           40,
                           50,
                           45,
                           70,
                           50,
                           80,
                           55,
                           60,
                           60,
                           100,
                           65,
                           110,
                           70,
                           120,
                           75,
                           130,
                           80,
                           140,
                           85)
where AppOrder is null;


update wf_prlba_pay_app f
   set f.apporder = decode(f.apptype,
                           0,
                           5,
                           10,
                           10,
                           20,
                           15,
                           25,
                           20,
                           26,
                           23,
                           28,
                           25,
                           30,
                           30,
                           90,
                           35,
                           40,
                           40,
                           50,
                           45,
                           70,
                           50,
                           80,
                           55,
                           60,
                           60,
                           100,
                           65,
                           110,
                           70,
                           120,
                           75,
                           130,
                           80,
                           140,
                           85)
where AppOrder is null;


update wf_prlba_baoxiao_app f
   set f.apporder = decode(f.apptype,
                           0,
                           5,
                           10,
                           10,
                           20,
                           15,
                           25,
                           20,
                           26,
                           23,
                           28,
                           25,
                           30,
                           30,
                           90,
                           35,
                           40,
                           40,
                           50,
                           45,
                           70,
                           50,
                           80,
                           55,
                           60,
                           60,
                           100,
                           65,
                           110,
                           70,
                           120,
                           75,
                           130,
                           80,
                           140,
                           85)
where AppOrder is null;

update wf_prlba_baoxiao_app f
   set f.appdept = f.apptype;
update wf_prlba_fee_app f
   set f.appdept = f.apptype;
update wf_prlba_pay_app f
   set f.appdept = f.apptype;

update wf_prlba_baoxiao_app f
   set f.apptype = f.apporder;
update wf_prlba_fee_app f
   set f.apptype = f.apporder;
update wf_prlba_pay_app f
   set f.apptype = f.apporder;

update wf_prlba_baoxiao_app f
   set f.apporder = decode(f.apporder,45,40,55,50) where f.apporder in (45,55);
update wf_prlba_fee_app f
   set f.apporder = decode(f.apporder,45,40,55,50) where f.apporder in (45,55);
update wf_prlba_pay_app f
   set f.apporder = decode(f.apporder,45,40,55,50) where f.apporder in (45,55);

commit;


create table wf_task_1705 as select * from wf_task;

--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid
              from wf_prlba_fee f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
               and exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_fee_') not in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    --更新
    update wf_prlba_fee_App a
       set AppOrder = AppOrder + 100
     where EntGid = R.Entgid
       and FlowGid = R.Flowgid
       and a.appdate <= (select max(t.appdate)
                           from wf_prlba_fee_App t
                          where t.entgid = a.entgid
                            and t.flowgid = a.flowgid
                            and t.appassign = '否决')
       and exists (select 1
              from wf_prlba_fee_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.appassign = '否决');
  
    --所有正在审批的流程，插入审批人
    P_prlba_fee_doApp(R.Entgid, R.Modelgid, R.Flowgid, '提交');
  
    --删除已经审批的审批人
    delete from wf_prlba_fee_App a
     where a.entgid = R.Entgid
       and a.flowgid = R.Flowgid
       and a.appdate is null
       and exists (select 1
              from wf_prlba_fee_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.apporder < 100
               and t.appdate is not null
               and t.apptype = a.apptype);
  
    --所有正在审批的流程，改成T2审批
    update wf_task t
       set (t.taskdefgid, t.code, t.name) =
           (select d.taskdefgid, d.code, d.name
              from wf_task_define d
             where d.entgid = R.ENTGID
               and d.modelgid = R.Modelgid
               and lower(d.code) like '%_t2')
     where t.entgid = R.ENTGID
       and t.flowgid = R.Flowgid
       and t.stat = 1;
  end loop;
end;
/



--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid
              from wf_prlba_pay f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
               and exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_pay_') not in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    --更新
    update wf_prlba_pay_App a
       set AppOrder = AppOrder + 100
     where EntGid = R.Entgid
       and FlowGid = R.Flowgid
       and a.appdate <= (select max(t.appdate)
                           from wf_prlba_pay_App t
                          where t.entgid = a.entgid
                            and t.flowgid = a.flowgid
                            and t.appassign = '否决')
       and exists (select 1
              from wf_prlba_pay_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.appassign = '否决');
  
    --所有正在审批的流程，插入审批人
    P_prlba_pay_doApp(R.Entgid, R.Modelgid, R.Flowgid, '提交');
  
    --删除已经审批的审批人
    delete from wf_prlba_pay_App a
     where a.entgid = R.Entgid
       and a.flowgid = R.Flowgid
       and a.appdate is null
       and exists (select 1
              from wf_prlba_pay_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.apporder < 100
               and t.appdate is not null
               and t.apptype = a.apptype);
  
    --所有正在审批的流程，改成T2审批
    update wf_task t
       set (t.taskdefgid, t.code, t.name) =
           (select d.taskdefgid, d.code, d.name
              from wf_task_define d
             where d.entgid = R.ENTGID
               and d.modelgid = R.Modelgid
               and lower(d.code) like '%_t2')
     where t.entgid = R.ENTGID
       and t.flowgid = R.Flowgid
       and t.stat = 1;
  end loop;
end;
/

--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid
              from wf_prlba_baoxiao f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
               and exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_baoxiao_') not in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    --更新
    update wf_prlba_baoxiao_App a
       set AppOrder = AppOrder + 100
     where EntGid = R.Entgid
       and FlowGid = R.Flowgid
       and a.appdate <= (select max(t.appdate)
                           from wf_prlba_baoxiao_App t
                          where t.entgid = a.entgid
                            and t.flowgid = a.flowgid
                            and t.appassign = '否决')
       and exists (select 1
              from wf_prlba_baoxiao_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.appassign = '否决');
  
    --所有正在审批的流程，插入审批人
    P_prlba_baoxiao_doApp(R.Entgid, R.Modelgid, R.Flowgid, '提交');
  
    --删除已经审批的审批人
    delete from wf_prlba_baoxiao_App a
     where a.entgid = R.Entgid
       and a.flowgid = R.Flowgid
       and a.appdate is null
       and exists (select 1
              from wf_prlba_baoxiao_App t
             where t.entgid = a.entgid
               and t.flowgid = a.flowgid
               and t.apporder < 100
               and t.appdate is not null
               and t.apptype = a.apptype);
  
    --所有正在审批的流程，改成T2审批
    update wf_task t
       set (t.taskdefgid, t.code, t.name) =
           (select d.taskdefgid, d.code, d.name
              from wf_task_define d
             where d.entgid = R.ENTGID
               and d.modelgid = R.Modelgid
               and lower(d.code) like '%_t2')
     where t.entgid = R.ENTGID
       and t.flowgid = R.Flowgid
       and t.stat = 1;
  end loop;
end;
/
