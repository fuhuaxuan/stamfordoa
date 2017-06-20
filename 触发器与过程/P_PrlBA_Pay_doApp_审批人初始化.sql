
create or replace procedure P_PrlBA_Pay_doApp(p_EntGid    varchar2, --��ҵGid
                                              p_ModelGid  varchar, --ģ��Gid
                                              p_FlowGid   varchar, --����Gid
                                              p_AppAssign varchar2 --���
                                              ) as
  v_Stage   varchar2(1024); -- ���̳���
  v_ErrText varchar2(1024); -- Oracle������Ϣ

  v_UsrGid      varchar2(32); --�û�Gid
  v_ModelCode   varchar2(32); --ģ�ʹ���
  v_DeptGid     varchar2(32); --��ǰ�û�����
  v_PreDeptCode varchar2(32); --�������Ŵ���

  v_AppFee number(20, 2);
begin
  commit;
  v_Stage := 'ȡ��������Ϣ';
  select nvl(payfee, 0),
         f.FillUsrGid,
         f.FillUsrDeptGid,
         substr(f.FillUsrDeptCode, 0, 4)
    into v_AppFee, v_UsrGid, v_DeptGid, v_PreDeptCode
    from wf_prlBA_Pay f
   where f.entgid = p_EntGid
     and f.flowgid = p_FlowGid;

  v_Stage := 'ȡ��ģ����Ϣ';
  select m.code
    into v_ModelCode
    from wf_model m
   where m.Entgid = p_EntGid
     and m.modelgid = p_ModelGid;

  if p_AppAssign <> '��ֹ' then
    --����������
    insert into wf_PrlBA_Pay_App
      (EntGid,
       FlowGid,
       dtlGid,
       AppGid,
       AppCode,
       AppName,
       AppOrder,
       AppType)
      select p_EntGid,
             p_FlowGid,
             sys_guid(),
             t.AppGid,
             t.AppCode,
             t.AppName,
             t.AppOrder,
             t.AppType
        from (select v.PostGid  AppGid,
                     v.PostCode AppCode,
                     v.PostName AppName,
                     10         AppOrder,
                     10         AppType
                from v_Post v
               where v.EntGid = p_EntGid
                 and v.deptGid = v_DeptGid
                 and v.atype = 10
                 and rownum = 1
              union
              select v.PostGid  AppGid,
                     v.PostCode AppCode,
                     v.PostName AppName,
                     15         AppOrder,
                     15         AppType
                from v_Post v
               where v.EntGid = p_EntGid
                 and v.deptGid = v_DeptGid
                 and v.atype = 20
                 and rownum = 1
              union
              select v.PostGid  AppGid,
                     v.PostCode AppCode,
                     v.PostName AppName,
                     20         AppOrder,
                     20         AppType
                from v_Post v
               where v.EntGid = p_EntGid
                 and v.deptGid = v_DeptGid
                 and v.atype = 30
                 and rownum = 1
              union
              select v.PostGid  AppGid,
                     v.PostCode AppCode,
                     v.PostName AppName,
                     25         AppOrder,
                     25         AppType
                from v_Post v
               where v.EntGid = p_EntGid
                 and v.deptGid = v_DeptGid
                 and v.atype = 33
                 and rownum = 1
                 and v_PreDeptCode <> '0004'
                 and v_AppFee <= 10000
              union
              select v.PostGid  AppGid,
                     v.PostCode AppCode,
                     v.PostName AppName,
                     30         AppOrder,
                     30         AppType
                from v_Post v
               where v.EntGid = p_EntGid
                 and v.deptGid = v_DeptGid
                 and v.atype = 35
                 and rownum = 1
                 and ((v_PreDeptCode <> '0004' and v_AppFee > 10000)
                  or v_PreDeptCode = '0004')
              union
              select o.AppGid, o.AppCode, o.AppName, 35 AppOrder, 35 AppType
                from v_wf_model_usr_app o
               where o.EntGid = p_EntGid
                 and o.ModelGid = p_ModelGid
                 and replace(lower(o.Modelcode), lower(v_ModelCode), '') in
                     ('_tb2')
                 and rownum = 1
                 and v_AppFee > 50000
              union
              select o.AppGid, o.AppCode, o.AppName, 40 AppOrder, 40 AppType
                from v_wf_model_usr_app o
               where o.EntGid = p_EntGid
                 and o.ModelGid = p_ModelGid
                 and replace(lower(o.Modelcode), lower(v_ModelCode), '') in
                     ('_tc1')
                 and rownum = 1
                 and v_AppFee > 50000
              union
              select u.gid  AppGid,
                     u.code AppCode,
                     u.name AppName,
                     40     AppOrder,
                     45     AppType
                from v_usr u, PRL_AcgSet s
               where u.entgid = p_EntGid
                 and u.entgid = s.entgid
                 and u.gid = s.AUsrGid
                 and exists (select 1
                        from wf_prlba_Pay f, prl_acg a
                       where f.entgid = s.entgid
                         and f.entgid = a.entgid
                         and f.acgtwogid = a.gid
                         and f.FlowGid = p_FlowGid
                         and s.ComGid = f.companygid
                         and lower(s.AcgCode) = lower(a.code))
                 and rownum = 1
                 and v_AppFee > 50000
              union
              select o.AppGid, o.AppCode, o.AppName, 50 AppOrder, 50 AppType
                from v_wf_model_usr_app o
               where o.EntGid = p_EntGid
                 and o.ModelGid = p_ModelGid
                 and replace(lower(o.Modelcode), lower(v_ModelCode), '') in
                     ('_tc3')
                 and rownum = 1
                 and v_AppFee > 50000
              union
              select o.AppGid, o.AppCode, o.AppName, 50 AppOrder, 55 AppType
                from v_wf_model_usr_app o
               where o.EntGid = p_EntGid
                 and o.ModelGid = p_ModelGid
                 and replace(lower(o.Modelcode), lower(v_ModelCode), '') in
                     ('_tc4')
                 and rownum = 1
                 and v_AppFee > 50000
              union
              select o.AppGid, o.AppCode, o.AppName, 60 AppOrder, 60 AppType
                from v_wf_model_usr_app o
               where o.EntGid = p_EntGid
                 and o.ModelGid = p_ModelGid
                 and replace(lower(o.Modelcode), lower(v_ModelCode), '') in
                     ('_td')
                 and rownum = 1
                 and v_AppFee > 50000) t;

    commit;
    --ȡ�����������ظ���������
    delete from wf_PrlBA_Pay_App f
     where f.EntGid = p_EntGid
       and f.FlowGid = p_FlowGid
       and f.Apporder > 0
       and f.Appdate is null
       and not exists (select 1
              from (select max(t.appType) appType,
                           t.EntGid,
                           t.FlowGid,
                           t.AppGid
                      from wf_PrlBA_Pay_App t
                     where t.EntGid = p_EntGid
                       and t.FlowGid = p_FlowGid
                       and t.AppOrder < 100
                       and t.AppDate is null
                     group by t.EntGid, t.FlowGid, t.AppGid) a
             where f.EntGid = a.EntGid
               and f.FlowGid = a.FlowGid
               and f.appType = a.appType);
  end if;
  commit;
  --�쳣����
exception
  when others then
    begin
      rollback;
      v_ErrText := substr('����Gid:' || p_FlowGid || ';�û�Gid:' || v_UsrGid ||
                          ';���:' || v_AppFee || ';' || v_Stage || ' ʧ��!' ||
                          SQLCode || ':' || SQLERRM,
                          1,
                          1024);
      --������־
      insert into Log
        (EntGid,
         EntCode,
         EntName,
         UsrGid,
         UsrCode,
         UsrName,
         CreateDate,
         Atype,
         AContent)
        select e.gid,
               e.code,
               e.name,
               'sys',
               'sys',
               'ϵͳ�Զ�',
               sysdate,
               30,
               v_ErrText
          from ent e
         where e.gid = p_EntGid;
      commit;
    end;
end;
/