
create function [dbo].[fn_tMmostExpensiveTeamsGet]
(
	@Date date
)
returns table
as
return
	select
		top 100 percent
		t.Name
		, sum(c.Amount) as TeamValue
	from dbo.Team t
		left join dbo.Contract c on c.TeamID = t.ID
				and @Date between c.ContractFrom and c.ContractTo
	group by t.ID
			, t.Name
	order by TeamValue desc;
