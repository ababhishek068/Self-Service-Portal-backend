Table 50074 "Applicant Register"
{
    LookupPageId = "Applicant Register";
    DrillDownPageId = "Applicant Register";
    fields
    {
        field(1; Email; Text[150]) { }
        field(2; "First Name"; Text[100]) { }
        field(3; "Middle Name"; Text[100]) { }
        field(4; "Last Name"; Text[100]) { }
        field(5; "ID Number"; Text[30]) { }
        field(6; "Passport Number"; Text[20]) { }
        field(7; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(8; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Nationality; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Phone Number"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Postal Address"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Living with Disability?"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(13; "Disability Details"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Single,Married,Separated,Divorced,Widow(er)';
            OptionMembers = ,Single,Married,Separated,Divorced,"Widow(er)";
        }
        field(15; "Email Verified?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Verification Token"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Token Expired?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Ethnicity; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Region; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Password; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Expected Salary"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Applicant Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,External,Internal';
            OptionMembers = " ",External,Internal;
        }
        field(23; "First Language (R/W/S)"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter(Language));
        }
        field(24; "Second Language (R/W/S)"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter(Language));
        }
        field(25; Picture; Media)
        {
            DataClassification = ToBeClassified;

        }
        field(26; "Account No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(27;"Employee ID"; code[20])
        {
            TableRelation="HR-Employee"."No." where(Status=const(Active));
            trigger OnValidate()
            begin
                if hremps.Get("Employee ID") then begin
                    "Last Name":=hremps."Last Name";
                    "Middle Name":=hremps."Middle Name";
                    "First Name":=hremps."First Name";
                    "ID Number":=hremps."ID Number";
                    Email:=hremps."E-Mail";
                    Gender:=hremps.Gender;
                    "Applicant Type":="Applicant Type"::Internal;
                    "Marital Status":=hremps."Marital Status";
                    "Date of Birth":=hremps."Date Of Birth";
                    "Living with Disability?":=hremps.Disabled;
                    "Phone Number":=hremps."Cell Phone Number";
                end;
            end;
        }

    }

    keys
    {
        key(Key1; "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    var
        NoSeriese: Codeunit "No. Series";
        HRSetUp: Record "HR Setup";
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        HRSetUp.get;
        HRSetUp.TestField("Applicants Nos.");
        if ("Account No" = '') then begin
            "Account No" := NoSeriese.GetNextNo(HRSetUp."Applicants Nos.", today, true);
        end;
    end;
    var
    hremps: Record "HR-Employee";
}

