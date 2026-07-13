Table 50196 "HR Medical Claims"
{
    DrillDownPageID = "HR Medical Claims List";
    LookupPageID = "HR Medical Claims List";

    fields
    {
        field(1; "Member No"; Code[10])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin

                HREmployees.SetRange(HREmployees."No.", "Member No");
                if HREmployees.Find('-') then
                    "Patient Name" := HREmployees."First Name" + ' ' + HREmployees."Middle Name" + ' ' + HREmployees."Last Name";
            end;
        }
        field(2; "Claim Type"; Option)
        {
            OptionMembers = Inpatient,Outpatient;
        }
        field(3; "Claim Date"; Date) { }
        field(4; "Patient Name"; Text[100]) { }
        field(5; "Document Ref"; Text[50]) { }
        field(6; "Date of Service"; Date) { }
        field(7; "Attended By"; Code[10])
        {
            TableRelation = Vendor."No.";
        }
        field(8; "Amount Charged"; Decimal) { }
        field(9; Comments; Text[250]) { }
        field(10; "Claim No"; Code[10])
        {

            trigger OnValidate()
            begin
                //CORETEC PROTECTED
                if "Claim No" <> xRec."Claim No" then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Medical Claims Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(11; Dependants; Code[50])
        {
            // TableRelation = "HR Employee Kin"."Other Names" where("Employee Code" = field("Member No"));

            // trigger OnValidate()
            // begin
            //     //CORETEC PROTECTED
            //     MDependants.Reset;
            //     MDependants.SetRange(MDependants."Employee No", Dependants);
            //     if MDependants.Find('-') then begin
            //         "Patient Name" := MDependants.Names ;
            //     end;
            // end;
        }
        field(12; "Member Name"; Text[100]) { }
        field(3967; "No. Series"; Code[10]) { }
    }

    keys
    {
        key(Key1; "Claim No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //CORETEC PROTECTED
        if "Claim No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Medical Claims Nos");
            "Claim No":=NoSeriesMgt.GetNextNo(HRSetup."Medical Claims Nos", 0D, true);
        end;
        "Claim Date" := Today;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "HR Setup";
        HREmployees: Record "HR-Employee";
}

