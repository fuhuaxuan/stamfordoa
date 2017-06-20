alter table wf_flow add (FillDeptGid varchar2(32) );
alter table wf_flow add (FillDeptCode varchar2(64) );
alter table wf_flow add (FillDeptName varchar2(128) );
alter table wf_rt add (DEPTRT varchar2(128) );

update wf_flow f
   set (f.filldeptgid, f.filldeptcode, f.filldeptname) =
       (select d.gid, d.code2, d.name
          from dept d, hr_emp hr
         where d.entgid = hr.entgid
           and hr.entgid = f.entgid
           and hr.usrgid = f.creatergid
           and hr.deptgid = d.gid)
 where f.entgid = getentgid;
