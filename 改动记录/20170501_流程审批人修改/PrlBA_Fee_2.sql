create table wf_task_070510 as select * from wf_task;

--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid, wf.FlowNote
              from wf_prlba_fee f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
                  
               and (select count(1)
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_fee_') in ('t2')) = 0
               and not exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_fee_') in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    insert into wf_task
      (EntGid,
       ModelGid,
       FlowGid,
       TaskDefGid,
       TaskGid,
       Code,
       Name,
       Note,
       STAT,
       ExecGid,
       ExecCode,
       ExecName,
       MEMO,
       Btime,
       OrderValue,
       OwnerValue,
       IsMCF)
      select R.entgid,
             R.ModelGid,
             R.flowGid,
             d.TaskDefGid,
             sys_guid(),
             d.code,
             d.name,
             d.note,
             1,
             a.AppGid,
             a.AppCode,
             a.AppName,
             R.FlowNote,
             sysdate,
             d.OrderValue,
             1,
             d.IsMCF
        from wf_task_define d,
             (select AppGid, Appcode, AppName, min(AppType) AppType
                from wf_prlba_fee_app t
               where t.entgid = R.Entgid
                 and t.flowgid = R.Flowgid
                 and t.AppDate is null
               group by AppGid, Appcode, AppName) a
       where d.entgid = R.ENTGID
         and d.modelgid = R.Modelgid
         and lower(d.code) like '%_t2';
  end loop;
end;
/


--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid, wf.FlowNote
              from wf_prlba_pay f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
                  
               and (select count(1)
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_pay_') in ('t2')) = 0
               and exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_pay_') not in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    insert into wf_task
      (EntGid,
       ModelGid,
       FlowGid,
       TaskDefGid,
       TaskGid,
       Code,
       Name,
       Note,
       STAT,
       ExecGid,
       ExecCode,
       ExecName,
       MEMO,
       Btime,
       OrderValue,
       OwnerValue,
       IsMCF)
      select R.entgid,
             R.ModelGid,
             R.flowGid,
             d.TaskDefGid,
             sys_guid(),
             d.code,
             d.name,
             d.note,
             1,
             a.AppGid,
             a.AppCode,
             a.AppName,
             R.FlowNote,
             sysdate,
             d.OrderValue,
             1,
             d.IsMCF
        from wf_task_define d,
             (select AppGid, Appcode, AppName, min(AppType) AppType
                from wf_prlba_pay_app t
               where t.entgid = R.Entgid
                 and t.flowgid = R.Flowgid
                 and t.AppDate is null
               group by AppGid, Appcode, AppName) a
       where d.entgid = R.ENTGID
         and d.modelgid = R.Modelgid
         and lower(d.code) like '%_t2';
  end loop;
end;
/


--更新数据
BEGIN
  --for 循环 取出所有的外网登记表数据
  for R in (select f.entgid, f.flowgid, wf.modelgid, wf.FlowNote
              from wf_prlba_baoxiao f, wf_flow wf
             where f.entgid = getentgid
               and f.stat in ('提交', '同意')
               and f.entgid = wf.entgid
               and f.flowgid = wf.flowgid
               and wf.stat < 3
                  
               and (select count(1)
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_baoxiao_') in ('t2')) = 0
               and not exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_baoxiao_') in
                           ('t1', 't4', 't5', 't6', 'tcc'))
             order by f.createdate) loop
    insert into wf_task
      (EntGid,
       ModelGid,
       FlowGid,
       TaskDefGid,
       TaskGid,
       Code,
       Name,
       Note,
       STAT,
       ExecGid,
       ExecCode,
       ExecName,
       MEMO,
       Btime,
       OrderValue,
       OwnerValue,
       IsMCF)
      select R.entgid,
             R.ModelGid,
             R.flowGid,
             d.TaskDefGid,
             sys_guid(),
             d.code,
             d.name,
             d.note,
             1,
             a.AppGid,
             a.AppCode,
             a.AppName,
             R.FlowNote,
             sysdate,
             d.OrderValue,
             1,
             d.IsMCF
        from wf_task_define d,
             (select AppGid, Appcode, AppName, min(AppType) AppType
                from wf_prlba_baoxiao_app t
               where t.entgid = R.Entgid
                 and t.flowgid = R.Flowgid
                 and t.AppDate is null
               group by AppGid, Appcode, AppName) a
       where d.entgid = R.ENTGID
         and d.modelgid = R.Modelgid
         and lower(d.code) like '%_t2';
  end loop;
end;
/


  delete 
              from wf_task f
             where f.entgid = getentgid
               and (select count(1)
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and t.stat = 1
                       and replace(lower(t.code), 'prlba_fee_') in
                           ('t2')) > 1
               and not exists
             (select 1
                      from wf_task t
                     where t.entgid = f.entgid
                       and t.flowgid = f.flowgid
                       and stat = 1
                       and replace(lower(t.code), 'prlba_fee_') in
                           ('t1', 't4', 't5', 't6', 'tcc'))
               and f.stat = 1
               and exists
             (select *
                      from wf_prlba_fee_app e
                     where e.flowgid = f.flowgid
                     and e.appgid = f.execgid
                     and e.appdate is null
                       and e.apptype >
                           (select min(a.apptype)
                              from wf_prlba_fee_app a
                             where a.flowgid = e.flowgid
                             and a.appdate is null))