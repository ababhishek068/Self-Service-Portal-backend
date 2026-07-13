Table 50290 "Student Requisitions"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Student No"; Code[20]) { }
        field(3; "Requisition Type"; Option)
        {
            OptionCaption = ',Campus Transfer,Programme Transfer,Student Defer,Re-admission After Deferment,Re-admission After Suspension,Change of Study mode,ID Replacement,Special Exams,Trascript Replacement,Clearance,Drop Courses,External Minor,External Major,Sponsorship';
            OptionMembers = ,"Campus Transfer","Programme Transfer","Student Defer","Re-admission After Deferment","Re-admission After Suspension","Change of Study mode","ID Replacement","Special Exams","Trascript Replacement",Clearance,"Drop Courses","External Minor","External Major",SponsorShip;
        }
        field(4; Date; Date) { }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled,Rejected;
            trigger OnValidate()
            var
                AppEntry: Record "Approval Entry";
                StudentRequisitions: Record "Student Requisitions";
                CourseRegistration: record "Course Registration";
                Sem: Record Semesters;
                AcademicYear: Record "Academic Year";
                StudTransfer: Record "Students Transfer";
            begin
                calcfields("Approved Count");
                if "Approved Count" > 0 then begin
                    AppEntry.RESET;
                    AppEntry.SETRANGE("Document No.", Code);
                    AppEntry.SETFILTER(Status, '<>%1', AppEntry.Status::Approved);
                    IF NOT AppEntry.FIND('-') THEN BEGIN
                        StudentRequisitions.RESET;
                        StudentRequisitions.SETRANGE(Code, Code);
                        IF StudentRequisitions.FIND('-') THEN BEGIN
                            StudentRequisitions.Status := StudentRequisitions.Status::Approved;
                            StudentRequisitions.MODIFY;
                        END;
                    END;
                end;
                if Status = Status::Approved then begin
                    if ("Requisition Type" = "Requisition Type"::"External Major") or ("Requisition Type" = "Requisition Type"::"External Minor") then begin
                        /* if Cust.get("Student No") then begin
                            cust."Other Programme" := Programme_To;
                            if "Requisition Type" = "Requisition Type"::"External Major" then
                                cust."Other programme Type" := cust."Other programme Type"::Major
                            else
                                cust."Other programme Type" := cust."Other programme Type"::Minor;
                            cust.modify;
                            cust.Validate("Other Programme");
                        end; */
                    end;
                    if ("Requisition Type" = "Requisition Type"::"Programme Transfer") then begin
                        CourseRegistration.SETRANGE("Student No.", "Student No");
                        CourseRegistration.SETFILTER("Settlement Type", '<>%1', '');
                        IF CourseRegistration.FIND('-') THEN BEGIN
                            Sem.RESET;
                            Sem.SETRANGE("Current Semester", TRUE);
                            IF Sem.FIND('-') THEN BEGIN
                                AcademicYear.RESET;
                                AcademicYear.SETRANGE(Current, TRUE);
                                IF AcademicYear.FIND('-') THEN BEGIN
                                    StudTransfer.INIT;
                                    StudTransfer."Student No" := "Student No";
                                    StudTransfer.VALIDATE("Student No");
                                    StudTransfer."Settlement Type" := CourseRegistration."Settlement Type";
                                    StudTransfer."Current Programme" := StudentRequisitions."Current Programme";
                                    StudTransfer.Semester := Sem.Code;
                                    StudTransfer."New Programme" := StudentRequisitions.Programme_To;
                                    StudTransfer.VALIDATE("New Programme");
                                    StudTransfer.Date := TODAY;
                                    StudTransfer."Academic Year" := AcademicYear.Code;
                                    StudTransfer."Posted By" := DATABASE.USERID;
                                    StudTransfer.INSERT(TRUE);
                                END ELSE
                                    ERROR('Current academic year not set');
                            END ELSE
                                ERROR('Current semester not set');
                        END ELSE
                            ERROR('Student settlement type not set');
                    end;
                end;
            end;
        }
        field(6; Programme_To; Code[20]) { }
        field(7; Semester; Code[20]) { }
        field(8; Stage; Code[20]) { }
        field(9; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(10; "Effective Date"; Date) { }
        field(11; "Last Date Attended"; Date) { }
        field(12; "Return Semester"; Text[40]) { }
        field(13; Campus_To; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Programme; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Reason; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Admission Portal?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Department"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "School"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Campus; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Town; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Phone Number"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Email; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(23; Address; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Current Programme"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Phone No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Names"; code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Weighted Mean"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Remarks"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Sequence No"; Integer)
        {
            CalcFormula = lookup("Approval Entry"."Sequence No." where("Document No." = field(Code),
                                                                        Status = filter(Open)));
            FieldClass = FlowField;
        }
        field(30; "Approval Count"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Salespers./Purch. Code" = FIELD("Student No")));
        }
        field(31; "Approved Count"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Salespers./Purch. Code" = FIELD("Student No"), Status = CONST(Approved)));
        }
        field(32; "Collection Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Certficated Issued"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Certificate Issue Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Certificate No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Certificate Issued By"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(40; Concentration; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(39; "Concentration Name"; Text[200])
        {
            DataClassification = ToBeClassified;

        }


        field(38; "Open In"; Option)
        {
            OptionCaption = ' ,Admission,Registra';
            OptionMembers = " ",Admission,Registra;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

