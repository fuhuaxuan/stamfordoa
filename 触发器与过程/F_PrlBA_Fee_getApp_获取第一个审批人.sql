

create or replace function F_PrlBA_getApp(p_EntGid   varchar2, --企业Gid
                                          p_ModelGid varchar2, --模型Gid
                                          p_UsrGid   varchar2, --用户Gid
                                          p_AppFee   varchar2, --审批金额
                                          p_ComGid  varchar2, --公司
                                          p_AcgCode  varchar2 --项目代码
                                          ) return varchar2 is
  v_Stage   varchar2(1024); -- 过程场景
  v_ErrText varchar2(1024); -- Oracle错误信息

  v_ModelCode   varchar2(32); --模型代码
  v_DeptGid     varchar2(32); --当前用户部门
  v_PreDeptCode varchar2(32); --所属部门代码

  v_AppGid varchar2(32); --变量（记录每天小时）
begin
  v_Stage := '取出流程信息';

  select d.Gid, substr(d.Code2, 0, 4)
    into v_DeptGid, v_PreDeptCode
    from hr_emp hr, dept d
   where hr.EntGid = p_EntGid
     and hr.EntGid = d.EntGid
     and hr.DeptGid = d.gid
     and hr.UsrGid = p_UsrGid;

  v_Stage := '取出模型信息';
  select m.code
    into v_ModelCode
    from wf_model m
   where m.Entgid = p_EntGid
     and m.modelgid = p_ModelGid;
  select AppGid
    into v_AppGid
    from (select *
            from (select max(t.AppType) AppType, t.AppGid
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
                             and p_AppFee <= 10000
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
                             and ((v_PreDeptCode <> '0004' and p_AppFee > 10000)
                              or v_PreDeptCode = '0004')
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 35        AppOrder,
                                 35        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_tb2')
                             and rownum = 1
                             and p_AppFee > 50000
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 40        AppOrder,
                                 40        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_tc1')
                             and rownum = 1
                             and p_AppFee > 50000
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
                             and s.ComGid = p_ComGid
                             and lower(s.AcgCode) = lower(p_AcgCode)
                             and p_AcgCode <> '-1'
                             and rownum = 1
                             and p_AppFee > 50000
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 40        AppOrder,
                                 45        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_tc2')
                             and p_AcgCode = '-1'
                             and rownum = 1
                             and p_AppFee > 50000
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 50        AppOrder,
                                 50        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_tc3')
                             and rownum = 1
                             and p_AppFee > 50000
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 50        AppOrder,
                                 55        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_tc4')
                             and rownum = 1
                             and p_AppFee > 50000
                          union
                          select o.AppGid,
                                 o.AppCode,
                                 o.AppName,
                                 60        AppOrder,
                                 60        AppType
                            from v_wf_model_usr_app o
                           where o.EntGid = p_EntGid
                             and o.ModelGid = p_ModelGid
                             and replace(lower(o.Modelcode),
                                         lower(v_ModelCode),
                                         '') in ('_td')
                             and rownum = 1
                             and p_AppFee > 50000) t
                   group by t.AppGid) a
           order by a.AppType)
   where rownum = 1;

  --返回计算结果
  return v_AppGid;
  --异常处理
exception
  when others then
    begin
      rollback;
      v_ErrText := substr('模型Gid:' || p_ModelGid || ';用户Gid:' || p_UsrGid ||
                          ';金额:' || p_AppFee || ';' || v_Stage || ' 失败!' ||
                          SQLCode || ':' || SQLERRM,
                          1,
                          1024);
      --插入日志
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
               '系统自动',
               sysdate,
               30,
               v_ErrText
          from ent e
         where e.gid = p_EntGid;
      commit;
    end;
end;
/