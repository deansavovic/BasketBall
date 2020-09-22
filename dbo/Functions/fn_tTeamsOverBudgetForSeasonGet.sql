CREATE function [dbo].[fn_tTeamsOverBudgetForSeasonGet]
(
	@SeasonLeagueID int
	, @Date date
)
returns table
as
return
	select
		t.Name
	from dbo.SeasonLeague sl
		inner join dbo.Season s on sl.SeasonID = s.ID
		inner join dbo.League l on sl.LeagueID = l.ID
		inner join dbo.Contract c on s.SeasonFrom between c.ContractFrom and c.ContractTo
				or s.SeasonTo between c.ContractFrom and c.ContractTo
		inner join dbo.Team t on c.TeamID = t.ID
		left join dbo.Injury i on c.PlayerID = i.PlayerID
				and @Date between i.InjuryFrom and i.InjuryTo
	where sl.ID = @SeasonLeagueID
		and @Date between c.ContractFrom and c.ContractTo
		and i.ID is null
	group by t.ID
			, t.Name
	having sum(c.Amount) > max(l.SalaryBudget);
