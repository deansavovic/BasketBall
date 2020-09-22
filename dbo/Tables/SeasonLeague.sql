CREATE TABLE [dbo].[SeasonLeague] (
    [ID]           INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SeasonID]     INT     NOT NULL,
    [LeagueID]     INT     NOT NULL,
    [NumOfPlayers] TINYINT CONSTRAINT [DF_SeasonLeague_NumOfPlayers] DEFAULT ((15)) NOT NULL,
    CONSTRAINT [PK_SeasonLeague] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_SeasonLeague_League] FOREIGN KEY ([LeagueID]) REFERENCES [dbo].[League] ([ID]),
    CONSTRAINT [FK_SeasonLeague_Season] FOREIGN KEY ([SeasonID]) REFERENCES [dbo].[Season] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_SeasonLeague]
    ON [dbo].[SeasonLeague]([LeagueID] ASC, [SeasonID] ASC);

