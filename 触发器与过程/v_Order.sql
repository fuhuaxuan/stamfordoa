
CREATE OR REPLACE VIEW v_Order AS
select f.entgid, f.flowgid, f.num, f.stat, f.sumfee applyfee,f.comname 
  from wf_prlba_baoxiao f
union
select f.entgid, f.flowgid, f.num, f.stat, f.askfee applyfee,f.COMPANYNAME comname
  from wf_prlba_fee f
union
select f.entgid, f.flowgid, f.num, f.stat, f.payfee applyfee,f.COMPANYNAME comname
  from wf_prlba_pay f
union
select f.entgid, f.flowgid, f.num, f.stat, 0 applyfee,'' comname
  from wf_prlba_cg f;