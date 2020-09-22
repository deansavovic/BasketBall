CREATE TABLE [dbo].[Player] (
    [ID]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FirstName] NVARCHAR (100) NOT NULL,
    [LastName]  NVARCHAR (100) NOT NULL,
    [TeamID]    INT            NULL,
    CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Player_Team] FOREIGN KEY ([TeamID]) REFERENCES [dbo].[Team] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TeamID]
    ON [dbo].[Player]([TeamID] ASC);


GO

CREATE TRIGGER [dbo].[TRG_Player_MaxNumOfPlayers]
   ON  [dbo].[Player] 
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;

	if exists (
		select
			1 as ReturnValue
		from (
			select
				distinct
				i.TeamID
				, sl.NumOfPlayers
			from inserted i
				inner join dbo.Team t on i.TeamID = t.ID
				inner join dbo.League l on t.LeagueID = l.ID
				inner join dbo.SeasonLeague sl on sl.LeagueID = l.ID
				inner join dbo.Season s on sl.SeasonID = s.ID
			where SYSDATETIME() between s.SeasonFrom and s.SeasonTo
		) t
			inner join dbo.Player p on t.TeamID = p.TeamID
			left join dbo.Injury i on p.ID = i.PlayerID
					and SYSDATETIME() between i.InjuryFrom and i.InjuryTo
		where i.ID is null
		group by p.TeamID
		having count(p.ID) > max(t.NumOfPlayers)
	)
	begin
		;throw 50000, 'Number of players exceeds the maximum number per season allowed!', 1;
	end

END
