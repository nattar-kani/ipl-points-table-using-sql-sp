USE tasks

--- table creation ---
CREATE TABLE IPL(
	team char(100) NOT NULL UNIQUE,
	won int NOT NULL,
	lost int NOT NULL,
	noResult int NOT NULL,
	points int NOT NULL,
	netRunRate FLOAT NOT NULL,
	playedMatch INT NOT NULL,
	CHECK (playedMatch<=14) --- check 14 matches
)

--- team primary key ---
ALTER TABLE IPL
ADD CONSTRAINT pkTeam PRIMARY KEY(team)

--- adding teams ---
INSERT INTO IPL VALUES
('CSK',0,0,0,0,0,0),
('GT',0,0,0,0,0,0),
('MI',0,0,0,0,0,0),
('RCB',0,0,0,0,0,0),
('RR',0,0,0,0,0,0)

--- sp for win ---
CREATE PROCEDURE sp_IPLwin @t1 char(100)
AS
UPDATE IPL SET won=won+1 WHERE team = @t1
UPDATE IPL SET netRunRate=netRunRate+2 WHERE team = @t1
UPDATE IPL SET points=points+2 WHERE team = @t1
UPDATE IPL SET playedMatch=playedMatch+1 WHERE team = @t1
SELECT * FROM IPL ORDER BY points DESC, netRunRate DESC
GO

--- sp for lost ---
CREATE PROCEDURE sp_IPLlost @t1 char(100)
AS
UPDATE IPL SET lost=lost+1 WHERE team = @t1
UPDATE IPL SET netRunRate=netRunRate+1 WHERE team = @t1
UPDATE IPL SET points=points+0 WHERE team = @t1
UPDATE IPL SET playedMatch=playedMatch+1 WHERE team = @t1
SELECT * FROM IPL ORDER BY points DESC, netRunRate DESC
GO

--- sp for draw ---
CREATE PROCEDURE sp_IPLdraw @t1 char(100), @t2 char(100)
AS
UPDATE IPL SET noResult=noResult+1 WHERE team = @t1
UPDATE IPL SET noResult=noResult+1 WHERE team = @t2
UPDATE IPL SET netRunRate=netRunRate+0.05 WHERE team = @t1
UPDATE IPL SET netRunRate=netRunRate+0.05 WHERE team = @t2
UPDATE IPL SET points=points+1 WHERE team = @t1
UPDATE IPL SET points=points+1 WHERE team = @t2
UPDATE IPL SET playedMatch=playedMatch+1 WHERE team = @t1
UPDATE IPL SET playedMatch=playedMatch+1 WHERE team = @t2
SELECT * FROM IPL ORDER BY points DESC, netRunRate DESC
GO

--- exec win sp ---
EXEC sp_IPLwin @t1='CSK'
GO

EXEC sp_IPLwin @t1='RCB'
GO

EXEC sp_IPLwin @t1='GT'
GO

--- exec lost sp ---
EXEC sp_IPLlost @t1='RR'
GO

EXEC sp_IPLlost @t1='GT'
GO

--- exec draw sp ---
EXEC sp_IPLdraw @t1='GT', @t2='MI'
GO

EXEC sp_IPLdraw @t1='RCB', @t2='RR'
GO

SELECT * FROM IPL




UPDATE IPL SET won = 0
UPDATE IPL SET lost = 0
UPDATE IPL SET noResult= 0
UPDATE IPL SET points = 0
UPDATE IPL SET netRunRate = 0
UPDATE IPL SET playedMatch = 0

DROP PROC sp_IPLwin;
go

DROP PROC sp_IPLlost;
go

DROP PROC sp_IPLdraw;
go

