Table 50764 "Archived Investment Header"
{
    //  DrillDownPageID = "HMS Setup Doctor Lists";
    // LookupPageID = "HMS Setup Doctor Lists";

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Name; Text[100]) { }
        field(3; "Investment Start Date"; Date) { }
        field(4; "Investment End Date"; Date)
        {

            trigger OnValidate()
            begin
                /* TESTFIELD("Investment Start Date");
                 IF "Investment End Date" <> 0D THEN
                 "Investment Duration" := DateCalc.DetermineAge("Investment Start Date","Investment End Date")
                 ELSE "Investment Duration" := '';
                
                IF "Investment Start Date" > "Investment End Date" THEN ERROR('End date cannot be earlier than start date');
                */

            end;
        }
        field(5; "Document Date"; Date) { }
        field(6; "Investment Firm Code"; Code[20])
        {
            Caption = 'Investment Company Code';
            TableRelation = "Investment Company"."Company Code";

            trigger OnValidate()
            begin
                if "Investment Firm Code" <> '' then begin
                    InvestmentFirm.Get("Investment Firm Code");
                    "Investment Firm Name" := InvestmentFirm."Company Name";
                end else begin
                    "Investment Firm Name" := '';
                end;
            end;
        }
        field(7; "Investment Firm Name"; Text[100])
        {
            Caption = 'Investment Company Code';
        }
        field(8; "Investment Rate"; Decimal)
        {
            TableRelation = "Investment Rates".Rate where(Type = filter(Interest));
        }
        field(9; "Investment Withholding Tax"; Decimal)
        {
            FieldClass = Normal;
        }
        field(10; "Investment Type"; Code[20])
        {
            TableRelation = "Investment Types";
        }
        field(11; "Investment Principal"; Decimal)
        {
            CalcFormula = sum("Payment Line".Amount where(No = field("Paying Document No."),
                                                           Type = const('INVESTMENT')));
            FieldClass = FlowField;
        }
        field(12; "Investment Duration"; Text[100]) { }
        field(13; "Investment Rollover Status"; Option)
        {
            OptionCaption = ' ,First Rollover,Closed';
            OptionMembers = " ","First Rollover",Closed;
        }
        field(14; "Interest Earned"; Decimal)
        {

            trigger OnValidate()
            begin


                "Investment Withholding Tax" := ("Withholding Tax Rate" / 100) * "Interest Earned";
            end;
        }
        field(15; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; Status; Option)
        {
            OptionCaption = ' ,Open,Pending Approval,Approved';
            OptionMembers = " ",Open,"Pending Approval",Approved;
        }
        field(17; "Paying Document No."; Code[30])
        {
            TableRelation = "Payments Header";
        }
        field(18; "Expected Interest"; Decimal) { }
        field(19; "Withholding Tax Rate"; Decimal)
        {
            TableRelation = "Investment Rates".Rate where(Type = filter("Withholding Tax"));

            trigger OnValidate()
            begin
                Validate("Interest Earned");
            end;
        }
        field(20; "Archived Versions"; Integer) { }
        field(21; "Responsibility Center"; Code[20]) { }
        field(22; "No of days elapsed"; Integer) { }
        field(50000; "Rollover Date"; Date) { }
        field(50001; "Version No."; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        if "No." = '' then begin
            "Investment Setup".Get;
            "Investment Setup".TestField("Investment Setup"."Investment Nos");
            "No.":=NoSeriesMgt.GetNextNo("Investment Setup"."Investment Nos",  0D,true);
        end;

        "Document Date" := Today;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        "Investment Setup": Record "Investment Setup";
        InvestmentFirm: Record "Investment Company";
}

