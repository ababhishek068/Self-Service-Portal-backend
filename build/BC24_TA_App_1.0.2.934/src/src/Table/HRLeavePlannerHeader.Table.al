table 50305 "HR Leave Planner Header"
{

    fields
    {
        field(1; "Application Code"; Code[20])
        {

            /*  trigger OnValidate()
             begin
                 //TEST IF MANUAL NOs ARE ALLOWED
                 if "Application Code" <> xRec."Application Code" then begin
                     HRSetup.GET;
                     NoSeriesMgt.TestManual(HRSetup."Leave Planner Nos.");
                     "No series" := '';
                 end;
             end; */
        }
        field(2; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,HOD Approval,HR Approval,Final Approval,Rejected,Canceled,Approved,On leave,Resumed,Posted';
            OptionMembers = New,"Pending Approval","HOD Approval","HR Approval",MDApproval,Rejected,Canceled,Approved,"On leave",Resumed,Posted;
        }
        field(3; "No series"; Code[30]) { }
        field(4; Picture; BLOB) { }
        field(5; Names; Text[100]) { }
        field(6; "Supervisor Email"; Text[30]) { }
        field(7; "Job Tittle"; Text[50]) { }
        field(8; "User ID"; Code[50]) { }
        field(9; "Employee No"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                Emp: Record "HR-Employee";
            begin
                if Emp.get("Employee No") then begin
                    Names := Emp."First Name" + ' ' + Emp."Last Name";
                    "Job Tittle" := Emp."Job ID";
                    "Job Description" := Emp."Job Title";
                    "Global Dimension 1 Code" := Emp."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := Emp."Global Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := Emp."Global Dimension 3 Code";
                end;
            end;
        }
        field(10; Supervisor; Code[40])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(11; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                /*
                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.",1);
                DimVal.SETRANGE(DimVal.Code,"Global Dimension 1 Code");
                 IF DimVal.FIND('-') THEN
                    "Function Name":=DimVal.Name;
                 UpdateLines;
                 */

            end;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin

                /*DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 2 Code");
                 IF DimVal.FIND('-') THEN
                    "Budget Center Name":=DimVal.Name ;
                UpdateLines
                */

            end;
        }
        field(15; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                /*
                DimVal.RESET;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 3 Code");
                 IF DimVal.FIND('-') THEN
                    Dim3:=DimVal.Name
                */

            end;
        }
        field(16; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                /*
                DimVal.RESET;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 4 Code");
                 IF DimVal.FIND('-') THEN
                    Dim4:=DimVal.Name
                  */

            end;
        }
        field(17; "Job Description"; Text[100]) { }
        field(18; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,Receipt,Staff Claim,Staff Advance,AdvanceSurrender,Store Requisition,Employee Requisition,Leave Application,Transport Requisition,Training Requisition,Job Approval,Induction Approval,Disciplinary Approvals,Activity Approval,Exit Approval,Medical Claim Approval,Jv,BackToOffice ,Training Needs,EmpTransfer,LeavePlanner';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs",EmpTransfer,LeavePlanner;
        }
        field(19; "Calendar Code"; Code[50])
        {
            TableRelation = "HR Leave Calendar".Code where(Current = filter(true));
        }
        field(20; "Date Applied"; Date) { }
    }

    keys
    {
        key(Key1; "Application Code") { }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        HRSetup: Record "HR Setup";
    begin
        HRSetup.get;
        HRSetup.TestField("Leave Planner Nos.");
        "Application Code" := NoSeriesMgt.GetNextNo(HRSetup."Leave Planner Nos.", today, true);
        "Date Applied" := Today;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
}

