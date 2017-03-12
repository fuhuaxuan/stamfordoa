drop table WF_PrlBA_CG_Dtl;			
create table WF_PrlBA_CG_Dtl (			
	EntGid 	varchar2(32)	not null,
	ModelGid	varchar2(32)	not null,
	FlowGid	varchar2(32)	not null,
	Gid	varchar2(32)	not null,
	--		
	Line	int	null,
	CGTitle	varchar2(128)	null,
	CGFee	Number(20,2)	null,
	CGMemo	varchar2(2000)	null,
	FeeNum	varchar2(32)	null,
	FeeFlowGid	varchar2(32)	null,
	FeeModelCode	varchar2(32)	null,
	constraint PK_WF_PrlBA_CG_Dtl primary key(EntGid, FlowGid, Gid)		
	);		

insert into WF_PrlBA_CG_Dtl
  (EntGid, ModelGid, FlowGid, Gid, line, CGTitle, CGFee, CGMemo)
  select f.entgid, f.ModelGid, f.FlowGid, sys_guid(), 1, f.CGTitle, f.CGFee, f.CGMemo
    from WF_PrlBA_CG f
   where f.entgid = getentgid;

update WF_PrlBA_CG f set f.CGMemo = '' where f.entgid = getentgid;
commit;