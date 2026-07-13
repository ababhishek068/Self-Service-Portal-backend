Table 50543 "Investment Header"
{

    fields
    {
        field(1; "No."; Code[20]) { }
        field(2; Name; Text[100]) { }
        field(3; "Investment Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if Format("Investment Duration") <> '' then
                    "Investment End Date" := CalcDate("Investment Duration", "Investment Start Date")
            end;
        }
        field(4; "Investment End Date"; Date) { }
        field(5; "Document Date"; Date) { }
        field(6; "Investment Company Code"; Code[20])
        {
            Caption = 'Investment Company Code';
            TableRelation = Customer."No." where("Customer Posting Group" = filter('FDR_INVEST'));

            trigger OnValidate()
            begin
                if "Investment Company Code" <> '' then begin
                    if Customer.Get("Investment Company Code") then
                        "Investment Company Name" := Customer.Name;
                end else begin
                    "Investment Company Name" := '';
                end;
            end;
        }
        field(7; "Investment Company Name"; Text[100])
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
        field(11; "Investment Principal"; Decimal) { }
        field(12; "Investment Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                TestField("Investment Start Date");

                "Investment End Date" := CalcDate("Investment Duration", "Investment Start Date")
            end;
        }
        field(13; "Investment Rollover Status"; Option)
        {
            OptionCaption = ' ,First Rollover,Closed';
            OptionMembers = " ","First Rollover",Closed;
        }
        field(14; "Interest Earned"; Decimal)
        {
            CalcFormula = sum("Investment Interest Schedule"."Interest Calculated" where("Investment No." = field("No."),
                                                                                          "Archived Versions" = field("Archived Versions"),
                                                                                          Posted = const(false)));
            FieldClass = FlowField;

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
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(17; "Paying Document No."; Code[30]) { }
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
        field(21; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(22; "No of days elapsed"; Integer) { }
        field(23; "USER ID"; Code[100]) { }
        field(24; "Investment Category"; Option)
        {
            OptionCaption = 'Fixed Deposit Reserves,Treasury Bills';
            OptionMembers = FDR,"Treasury Bills";
        }
        field(25; "Treasury Bond Rate"; Decimal)
        {
            TableRelation = "Investment Rates".Rate where(Type = filter(Interest));
        }
        field(26; "Treasury Bond Disposal Value"; Decimal) { }
        field(27; "Face Value"; Decimal) { }
        field(28; "Issue No"; Text[30]) { }
        field(29; "TB days"; Integer) { }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(32; "Interest Posted"; Decimal)
        {
            CalcFormula = sum("Investment Interest Schedule"."Interest Calculated" where("Investment No." = field("No."),
                                                                                          "Archived Versions" = field("Archived Versions"),
                                                                                          Posted = const(true)));
            FieldClass = FlowField;

            trigger OnValidate()
            begin


                "Investment Withholding Tax" := ("Withholding Tax Rate" / 100) * "Interest Earned";
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50000; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Account Transfer","Custom 3","Custom 4","Custom 5";
        }
        field(50001; "Bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(50002; "Bank Description"; Text[50])
        {
            CalcFormula = lookup("Bank Account".Name where("No." = field("Bank No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Principal Posted"; Boolean)
        {
            Editable = false;
        }
        field(50004; Posted; Boolean) { }
        field(50005; "Date Posted"; Date) { }
        field(50006; "Time Posted"; Time) { }
        field(50007; "Posted By"; Code[50]) { }
        field(50008; "Investment Posting Group"; Code[20])
        {
            TableRelation = "Investment Posting Setup";
        }
    }

    keys
    {
        key(Key1; "No.", "Archived Versions")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            if "Investment Category" = "investment category"::FDR then begin
                "Investment Setup".Get;
                "Investment Setup".TestField("Investment Setup"."Investment Nos");
                "No." := NoSeriesMgt.GetNextNo("Investment Setup"."Investment Nos", 0D, true);
            end else
                if "Investment Category" = "investment category"::"Treasury Bills" then begin
                    "Investment Setup".Get;
                    "Investment Setup".TestField("Investment Setup"."Treasury Bill Nos");
                    "No." := NoSeriesMgt.GetNextNo("Investment Setup"."Treasury Bill Nos", 0D, true);

                end;
        end;

        "Document Date" := Today;
        "USER ID" := UserId;
        Status := Status::"Pending Approval";
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        "Investment Setup": Record "Investment Setup";
        //DateCalc: Codeunit UnknownCodeunit50001;
        Customer: Record Customer;
        //PaymentsHeader: Record UnknownRecord70134873; //Payments Header
        DimMgt: Codeunit DimensionManagement;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
    end;
}

