

CREATE function [dbo].[fn_tLuxuryTaxGet] ()
returns table
as
return
	select
		t.ID
		, t.Name
		, sum(c.Amount) - max(l.SalaryBudget) as LuxuryTax
	from dbo.Team t
		inner join dbo.League l on t.LeagueID = l.ID
		inner join dbo.Contract c on t.ID = c.TeamID
				and SYSDATETIME() between c.ContractFrom and c.ContractTo
		left join dbo.Injury i on c.PlayerID = i.PlayerID
				and SYSDATETIME() between i.InjuryFrom and i.InjuryTo
	where i.ID is null
	group by t.ID
			, t.Name
	having sum(c.Amount) > max(l.SalaryBudget);
