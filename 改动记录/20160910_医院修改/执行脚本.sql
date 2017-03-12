CREATE OR REPLACE VIEW v_Order AS
select f.entgid, f.flowgid, f.num, f.stat
  from wf_prlba_baoxiao f
union
select f.entgid, f.flowgid, f.num, f.stat
  from wf_prlba_fee f
union
select f.entgid, f.flowgid, f.num, f.stat
  from wf_prlba_pay f
union
select f.entgid, f.flowgid, f.num, f.stat
  from wf_prlba_cg f;
