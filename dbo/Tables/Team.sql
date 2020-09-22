CREATE TABLE [dbo].[Team] (
    [ID]       INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]     NVARCHAR (100) NOT NULL,
    [LeagueID] INT            NOT NULL,
    CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Team_League] FOREIGN KEY ([LeagueID]) REFERENCES [dbo].[League] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_LeagueID]
    ON [dbo].[Team]([LeagueID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Team]
    ON [dbo].[Team]([Name] ASC, [LeagueID] ASC);

