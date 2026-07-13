Table 50176 "Service Disciplinary Cases"
{
    // LookupPageID = "Petty Cash";

    fields
    {
        field(1; "Case Number"; Code[20]) { }
        field(3; "Date of Complaint"; Date) { }
        field(4; "Type Complaint"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Lookup Values".Code where(Type = const("Disciplinary Case"));
        }
        field(5; "Recommended Action"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Disciplinary Action"));
        }
        field(6; "Description of Complaint"; Text[250]) { }
        field(7; Accuser; Code[10])
        {
            TableRelation = "Registration Form"."Serial No";

            trigger OnValidate()
            begin
                /* if "Accused Employee" = Accuser then
                    Error('An service cannot accuse his/her self');

                
                if Emp.get(Accuser) then
                    "Accuser Name" := Emp."Full Names"; */
            end;
        }
        field(8; "Witness #1"; Code[20])
        {
            TableRelation = "Registration Form"."Serial No";

            trigger OnValidate()
            var
                Emp: record "Registration Form";
            begin
                if "Accused Employee" = "Witness #1" then
                    Error('An service cannot witness his/her self');


                if Emp.get("Witness #1") then
                    "Accuser Name" := Emp."Full Names";
            end;
        }
        field(9; "Witness #2"; Code[20])
        {
            TableRelation = "Registration Form"."Serial No";

            trigger OnValidate()
            var
                Emp: record "Registration Form";
            begin
                if "Accused Employee" = "Witness #2" then
                    Error('An service cannot witness his/her self');


                if Emp.get("Witness #2") then
                    "Accuser Name" := Emp."Full Names";
            end;
        }
        field(10; "Action Taken"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Disciplinary Action"));
        }
        field(11; "Date To Discuss Case"; Date) { }
        field(12; "Document Link"; Text[200]) { }
        field(13; "Disciplinary Remarks"; Code[50]) { }
        field(14; Comments; Text[250]) { }
        field(15; "Case Discussion"; Boolean) { }
        field(16; "Body Handling The Complaint"; Code[100])
        {
            TableRelation = "HR Committees".Code;
        }
        field(17; Recomendations; Code[10]) { }
        field(18; "HR/Payroll Implications"; Integer) { }
        field(19; "Support Documents"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(20; "Policy Guidlines In Effect"; Code[10])
        {
            TableRelation = "HR Policies".Code;
        }
        field(21; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved';
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(22; "Mode of Lodging the Complaint"; Text[30]) { }
        field(23; "No. Series"; Code[20]) { }
        field(24; "Accused Employee"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                Emp.Reset;
                Emp.SetRange(Emp."Serial No", "Accused Employee");
                if Emp.Find('-') then
                    "Accused Employee Name" := Emp."Full Names";
            end;
        }
        field(25; Selected; Boolean) { }
        field(26; "Closed By"; Code[20]) { }
        field(3963; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR";
        }
        field(3964; "Accuser Name"; Text[40]) { }
        field(3965; "Witness #1 Name"; Text[50]) { }
        field(3966; "Witness #2  Name"; Text[50]) { }
        field(3967; "Disciplinary Stage Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Reported,Investigation ,Inprogress,Closed,Under review';
            OptionMembers = " ",Reported,"Investigation ",Inprogress,Closed,"Under review";
        }
        field(3968; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Store Requisition,Employee Requisition,Leave Application,Transport Requisition,Training Requisition,Job Approval,Induction Approval,Disciplinary Approvals,Activity Approval';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval";
        }
        field(3969; "User ID"; Code[50]) { }
        field(3970; "Accused Employee Name"; Text[100]) { }
        field(3971; "Accussed By"; Option)
        {
            OptionMembers = Employee,"Non-Employee";
        }
        field(3972; "Non Employee Name"; Text[100])
        {

            trigger OnValidate()
            begin
                if "Accussed By" = "accussed by"::Employee then
                    Error('You are not allowed to Type Name if accused is an employee');
            end;
        }
        field(3973; Appealed; Boolean) { }
        field(50000; "Date of Complaint was Reported"; Date) { }
        field(50001; "Severity Of the Complain"; Option)
        {
            OptionMembers = Major,Minor;
        }
    }

    keys
    {
        key(Key1; "Accused Employee", "Case Number")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Case Number" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Disciplinary Nos");
            "Case Number":=NoSeriesMgt.GetNextNo(HRSetup."Disciplinary Nos", 0D, true);
        end;

        "User ID" := UserId;
        "Date of Complaint" := Today;
    end;

    trigger OnModify()
    begin
        /*IF Status=Status::"" THEN
        ERROR('You cannot modify a case Under Investigation');
         */

    end;

    var
        HRSetup: Record "NYS Service Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Emp: Record "Registration Form";
}

