Table 50382 "Project Donors"
{

    fields
    {
        field(1; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            NotBlank = true;
            TableRelation = Customer."No." where("Account Type" = filter(Donor));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 1 Code");
                if DimVal.Find('-') then
                    "Donor Name" := DimVal.Name;
            end;
        }
        field(2; "Donor Name"; Text[100]) { }
        field(3; "Expected Donation"; Decimal) { }
        field(4; "Grant No"; Code[50])
        {
            NotBlank = true;
        }
        field(5; "Reporting Date"; Date)
        {
            Enabled = false;
        }
        field(6; "Donated Amount"; Decimal)
        {
            // CalcFormula = sum(Receipt.Field27084440);
            FieldClass = FlowField;
        }
        field(7; Balance; Decimal) { }
        field(8; "Indirect Cost"; Boolean) { }
        field(9; Percentage; Decimal)
        {

            trigger OnValidate()
            begin
                if "Indirect Cost" = true then begin
                    "Allowed Indirect Cost" := Percentage / 100 * "Expected Donation";
                end;
            end;
        }
        field(10; "Allowed Indirect Cost"; Decimal) { }
        field(11; "Charge Type"; Option)
        {
            OptionCaption = ' ,Accrual,Cash';
            OptionMembers = " ",Accrual,Cash;
        }
        field(12; "Contact Person"; Text[50]) { }
        field(13; Address; Text[30]) { }
    }

    keys
    {
        key(Key1; "Shortcut Dimension 1 Code", "Grant No")
        {
            Clustered = true;
        }
        key(Key2; "Grant No")
        {
            SumIndexFields = "Expected Donation";
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*objJobs.RESET;
        objJobs.SETRANGE(objJobs."No.","Grant No");
        IF objJobs.FIND('-') THEN ERROR('Sorry you cannot add donors for an already converted project');
             */

    end;

    var
        DimVal: Record "Dimension Value";
}

