CREATE TABLE UpdateMedication(
	updateID INT PRIMARY KEY IDENTITY(1,1),
    medicationID INT,
	phdID INT,
    oldPrice INT,
    newPrice INT,
    updateDate DATETIME
);
GO

CREATE OR ALTER PROCEDURE UpdateMedicationPrice
    @MedicationID INT,
	@PhdID INT,
    @NewMedicationPrice INT
AS
BEGIN
    DECLARE @OldMedicationPrice INT;

    SELECT @OldMedicationPrice = A.price
    FROM AvailableMedications A
    WHERE A.medicationID = @MedicationID AND A.phdID = @PhdID;

    UPDATE AvailableMedications
    SET price = @NewMedicationPrice
    WHERE medicationID = @MedicationID AND phdID = @PhdID;

    INSERT INTO UpdateMedication(medicationID,phdID,oldPrice, newPrice, updateDate)
    VALUES (@MedicationID,@PhdID,@OldMedicationPrice, @NewMedicationPrice, GETDATE());
END;
GO

CREATE OR ALTER PROCEDURE CursorImplementation
AS
BEGIN;

	SELECT * FROM AvailableMedications;

	DECLARE MedicationCursor CURSOR FOR
	SELECT medicationID,phdID,price
	FROM AvailableMedications

	DECLARE @MedicationID INT, @PhdID INT,@OldPrice INT, @NewPrice INT;
	DECLARE @PercentageIncrease DECIMAL(5,2);
	DECLARE @MaxPrice INT;
	SET @MaxPrice = 60;
	SET @PercentageIncrease = 5.0;

	OPEN MedicationCursor
	FETCH NEXT FROM MedicationCursor INTO @MedicationID,@PhdID, @OldPrice;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @NewPrice = ROUND(@OldPrice * (1 + @PercentageIncrease / 100), 0);

		IF @NewPrice <= @MaxPrice
		BEGIN
			EXEC UpdateMedicationPrice @MedicationID, @PhdID, @NewPrice;
		END
		FETCH NEXT FROM MedicationCursor INTO @MedicationID, @PhdID, @OldPrice;
	END;
	CLOSE MedicationCursor;
	DEALLOCATE MedicationCursor;

	SELECT * FROM UpdateMedication;
	SELECT * FROM AvailableMedications;


END;
GO

EXEC CursorImplementation;