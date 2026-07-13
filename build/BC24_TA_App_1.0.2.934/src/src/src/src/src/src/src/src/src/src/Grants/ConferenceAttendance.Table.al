Table 50409 "Conference Attendance"
{

    fields
    {
        field(1; "Req No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Req. Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Student,Staff';
            OptionMembers = ,Student,Staff;
        }
        field(3; Name; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Phone; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Email; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "I.D. Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Degree Program"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Programme.Code;
        }
        field(8; "Total Amount Requested"; Decimal)
        {
            CalcFormula = sum("Conference Lines".Total where("No." = field("Req No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Title of Research"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date of Presentation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "First Time Presention"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Conference Funding Before"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Req. Category" = const(Student)) Customer."No."
            else
            if ("Req. Category" = const(Staff)) Employee."No.";

            trigger OnValidate()
            begin
                if cust.Get("No.") then
                    Name := cust.Name;
                if emp.Get("No.") then
                    Name := emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
            end;
        }
        field(14; "P.H.D Programme"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Programme.Code;
        }
        field(15; "Comfirmed Attachements?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Semester/Year"; Code[30])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Semesters.Code;
        }
        field(17; "Requested Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Requested By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval, Cancelled,Approved,Rejected';
            OptionMembers = New,"Pending Approval"," Cancelled",Approved,Rejected;
        }
        field(20; "Project Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(21; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(22; "Project No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Jobs."No.";
            trigger OnValidate()
            var
                Jb: Record jobs;
            begin
                if jb.get("Project No.") then "Project Name" := jb.Description;
            end;
        }

    }

    keys
    {
        key(Key1; "Req No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Credit Memo Nos.");
            "Req No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Credit Memo Nos.",  0D, true);
        end;
    end;

    var
        cust: Record Customer;
        emp: Record Employee;
        GenLedgerSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

