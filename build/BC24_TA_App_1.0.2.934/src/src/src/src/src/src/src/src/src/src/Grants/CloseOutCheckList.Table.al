Table 50413 "Close Out Check List"
{
    // DrillDownPageID = "Counties Card";
    //  LookupPageID = "Counties Card";

    fields
    {
        field(1; "Grant No"; Code[20])
        {
            TableRelation = Jobs."No.";

            trigger OnValidate()
            begin
                objJobs.Reset;
                objJobs.SetRange(objJobs."No.", "Grant No");
                if objJobs.Find('-') then begin
                    Description := objJobs.Description;
                    User := UserId;
                    "Responsibility Center" := objJobs."Responsibility Center";
                    "Donor/Sponsor Code" := objJobs."Main Donor";
                    Date := Today;
                    PI := objJobs."Principal Investigator";
                    objResource.Reset;
                    objResource.SetRange(objResource."No.", objJobs."Principal Investigator");
                    if objResource.Find('-') then "PI Name" := objResource.Name;
                    Modify;
                end;
            end;
        }
        field(2; "Compliance Code"; Code[20]) { }
        field(3; Description; Text[250]) { }
        field(4; Compliance; Boolean) { }
        field(5; User; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(6; Amount; Decimal) { }
        field(7; Comments; Text[250]) { }
        field(8; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(9; "Closeout No."; Code[50])
        {

            trigger OnValidate()
            begin
                if "Closeout No." <> xRec."Closeout No." then begin
                    JobSetup.Get;
                    NoSeriesMgt.TestManual(JobSetup."Closeout Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(10; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; "Donor/Sponsor Code"; Code[100]) { }
        field(13; "Subcontractor no"; Text[70]) { }
        field(14; Date; Date) { }
        field(15; Subcontractor; Text[70]) { }
        field(16; PI; Code[50]) { }
        field(17; "PI Name"; Text[200]) { }
    }

    keys
    {
        key(Key1; "Closeout No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Closeout No." = '' then begin
            JobSetup.Get;
            JobSetup.TestField(JobSetup."Closeout Nos");
            "Closeout No.":=NoSeriesMgt.GetNextNo(JobSetup."Closeout Nos",  0D, true);
        end;
    end;

    var
        JobSetup: Record "Jobs-Setup";
        NoSeriesMgt: Codeunit "No. Series";
        objJobs: Record Jobs;
        objResource: Record Resource;
}

