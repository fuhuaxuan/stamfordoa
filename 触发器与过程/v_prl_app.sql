create or replace view v_prl_app as
select f.entgid,
       f.flowgid,
       f.appgid,
       f.appcode,
       f.appname,
       f.appassign,
       f.apptype,
       f.appdate,
       f.appmemo
  from wf_prlba_baoxiao_app f
union
select f.entgid,
       f.flowgid,
       f.appgid,
       f.appcode,
       f.appname,
       f.appassign,
       f.apptype,
       f.appdate,
       f.note
  from wf_prlba_fee_app f
union
select f.entgid,
       f.flowgid,
       f.appgid,
       f.appcode,
       f.appname,
       f.appassign,
       f.apptype,
       f.appdate,
       f.note
  from wf_prlba_pay_app f
union
select f.entgid,
       f.flowgid,
       f.appgid,
       f.appcode,
       f.appname,
       f.appassign,
       f.apptype,
       f.appdate,
       f.appmemo
  from wf_prlba_cg_app f;
