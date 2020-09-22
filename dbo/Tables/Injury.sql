CREATE TABLE [dbo].[Injury] (
    [ID]         INT  IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PlayerID]   INT  NOT NULL,
    [InjuryFrom] DATE NOT NULL,
    [InjuryTo]   DATE NULL,
    CONSTRAINT [PK_Injury] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_Injury_InjuryFrom_To] CHECK ([InjuryFrom]<[InjuryTo] OR [InjuryTo] IS NULL),
    CONSTRAINT [FK_Injury_Player] FOREIGN KEY ([PlayerID]) REFERENCES [dbo].[Player] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Injury_PlayerID]
    ON [dbo].[Injury]([PlayerID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Injury]
    ON [dbo].[Injury]([PlayerID] ASC, [InjuryFrom] ASC);

