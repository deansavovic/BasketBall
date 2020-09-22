
create function [dbo].[fn_tMostExpensivePlayersGet]
(
	@Date date = '2020-01-01'
)
returns table
as
return
	select
		top (1) with ties
		p.FirstName + ' ' + p.LastName as PlayerName
		, sum (c.Amount) as PlayerValue
	from dbo.Player p
		inner join dbo.Contract c on p.ID = c.PlayerID
				and @Date between c.ContractFrom and c.ContractTo
	group by p.ID
			, p.FirstName
			, p.LastName
	order by PlayerValue desc;
