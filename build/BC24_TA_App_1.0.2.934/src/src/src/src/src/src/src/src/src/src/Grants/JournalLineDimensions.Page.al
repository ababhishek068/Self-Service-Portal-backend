Page 50085 "Journal Line Dimensions"
{
    Caption = 'Journal Line Dimensions';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Journal Line Dimension";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(DimensionCode; Rec."Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension Code field.';
                }
                field(DimensionValueCode; Rec."Dimension Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension Value Code field.';
                }
            }
        }
    }

    actions { }

    var
        CurrTableID: Integer;
        CurrLineNo: Integer;
        SourceTableName: Text[100];

    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        NewTableID: Integer;
    begin
        NewTableID := GetTableID(Rec.GetFilter("Table ID"));
        if NewTableID = 0 then
            exit('');

        if NewTableID = 0 then
            SourceTableName := ''
        else
            if NewTableID <> CurrTableID then
                SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, NewTableID);

        CurrTableID := NewTableID;

        if Rec.GetFilter("Journal Line No.") = '' then
            CurrLineNo := 0
        else
            if Rec.GetRangeMin("Journal Line No.") = Rec.GetRangemax("Journal Line No.") then
                CurrLineNo := Rec.GetRangeMin("Journal Line No.")
            else
                CurrLineNo := 0;

        if NewTableID = 0 then
            exit('')
        else
            exit(StrSubstNo('%1 %2', SourceTableName, Format(CurrLineNo)));
    end;

    procedure GetTableID(TableIDFilter: Text[250]): Integer
    var
        NewTableID: Integer;
    begin
        if Evaluate(NewTableID, TableIDFilter) then
            exit(NewTableID)
        else
            exit(0);
    end;
}

