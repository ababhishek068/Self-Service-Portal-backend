tableextension 50030 "Job Entry Ext" extends "Job Entry No."
{
    fields
    {
        // Add changes to table fields here
    }

    procedure GetNextEntryNo(): Integer
    begin
        LOCKTABLE;
        IF NOT GET THEN
            INSERT;
        "Entry No." := "Entry No." + 1;
        MODIFY;
        EXIT("Entry No.");
    end;
}