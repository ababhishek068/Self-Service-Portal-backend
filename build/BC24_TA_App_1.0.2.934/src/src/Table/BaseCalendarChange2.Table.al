Table 50657 "Base Calendar Change2"
{
    Caption = 'Base Calendar Change';
    DataCaptionFields = "Base Calendar Code";

    fields
    {
        field(1; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            Editable = false;
            TableRelation = "Base Calendar";
        }
        field(2; "Recurring System"; Option)
        {
            Caption = 'Recurring System';
            OptionCaption = ' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";

            trigger OnValidate()
            begin
                if "Recurring System" <> xRec."Recurring System" then
                    case "Recurring System" of
                        "recurring system"::"Annual Recurring":
                            "Date Day" := "date day"::" ";
                        "recurring system"::"Weekly Recurring":
                            Date := 0D;
                    end;
            end;
        }
        field(3; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            begin
                if ("Recurring System" = "recurring system"::" ") or
                   ("Recurring System" = "recurring system"::"Annual Recurring")
                then
                    TestField(Date)
                else
                    TestField(Date, 0D);
                UpdateDayName;
            end;
        }
        field(4; "Date Day"; Option)
        {
            Caption = 'Day';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate()
            begin
                if "Recurring System" = "recurring system"::"Weekly Recurring" then
                    TestField("Date Day");
                UpdateDayName;
            end;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            InitValue = true;
        }
        field(39003900; "Date Month"; Option)
        {
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
    }

    keys
    {
        key(Key1; "Base Calendar Code", "Recurring System", Date, "Date Day")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        CheckEntryLine;
    end;

    trigger OnModify()
    begin
        CheckEntryLine;
    end;

    trigger OnRename()
    begin
        CheckEntryLine;
    end;

    procedure UpdateDayName()
    var
        DateTable: Record Date;
    begin
        if (Date > 0D) and
           ("Recurring System" = "recurring system"::"Annual Recurring")
        then
            "Date Day" := "date day"::" "
        else begin
            DateTable.SetRange("Period Type", DateTable."period type"::Date);
            DateTable.SetRange("Period Start", Date);
            if DateTable.FindFirst then
                "Date Day" := DateTable."Period No.";
        end;
        if (Date = 0D) and ("Date Day" = "date day"::" ") then begin
            "Date Day" := xRec."Date Day";
            Date := xRec.Date;
        end;
        if "Recurring System" = "recurring system"::"Annual Recurring" then
            TestField("Date Day", "date day"::" ");
    end;

    procedure CheckEntryLine()
    begin
        case "Recurring System" of
            "recurring system"::" ":
                begin
                    TestField(Date);
                    TestField("Date Day");
                end;
            "recurring system"::"Annual Recurring":
                begin
                    TestField(Date);
                    TestField("Date Day", "date day"::" ");
                end;
            "recurring system"::"Weekly Recurring":
                begin
                    TestField(Date, 0D);
                    TestField("Date Day");
                end;
        end;
    end;
}

