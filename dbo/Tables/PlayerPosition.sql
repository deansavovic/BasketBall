CREATE TABLE [dbo].[PlayerPosition] (
    [PlayerID]   INT NOT NULL,
    [PositionID] INT NOT NULL,
    CONSTRAINT [PK_PlayerPosition] PRIMARY KEY CLUSTERED ([PlayerID] ASC, [PositionID] ASC),
    CONSTRAINT [FK_PlayerPosition_Player] FOREIGN KEY ([PlayerID]) REFERENCES [dbo].[Player] ([ID]),
    CONSTRAINT [FK_PlayerPosition_Position] FOREIGN KEY ([PositionID]) REFERENCES [dbo].[Position] ([ID])
);

