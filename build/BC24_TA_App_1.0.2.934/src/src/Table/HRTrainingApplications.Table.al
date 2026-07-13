Table 50802 "HR Training Applications"
{
    // DrillDownPageID = UnknownPage70135489;
    //  LookupPageID = UnknownPage70135489;

    fields
    {
        field(1; "Application No"; Code[20])
        {
            Editable = true;

            trigger OnValidate()
            begin
                if "Employee No." <> xRec."Employee No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Training Application Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Course Title"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Training Courses"."Course Code" where(Closed = const(false),
                                                                       "Individual Course" = const(false));

            trigger OnValidate()
            var
                HRTrainingNeeds: Record "HR Training Needs Analysis";
                HRTrainingCourses: Record "HR Training Courses";
            begin

                HRTrainingNeeds.Reset;
                HRTrainingNeeds.SetRange(HRTrainingNeeds."Course Code", "Course Title");
                if HRTrainingNeeds.Find('-') then begin
                    "From Date" := HRTrainingNeeds."Proposed Start Date";
                    "To Date" := HRTrainingNeeds."Proposed End Date";
                end;

                HRTrainingCourses.Reset();
                IF HRTrainingCourses.Get("Course Title") THEN begin
                    Description := HRTrainingCourses."Course Tittle";
                    "From Date" := HRTrainingCourses."Start Date";
                    "To Date" := HRTrainingCourses."End Date";
                end;
            end;
        }
        field(3; "From Date"; Date)
        {
            Editable = true;
        }
        field(4; "To Date"; Date)
        {
            Editable = true;
        }
        field(5; "Duration Units"; Option)
        {
            Editable = true;
            OptionMembers = Hours,Days,Weeks,Months,Years;
        }
        field(6; Duration; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                /*
                                begin
                                    if (Duration <> 0) and ("From Date" <> 0D) then
                                        "To Date" := HRTrainApp.DetermineLeaveReturnDate("From Date", Duration);
                                    Modify;
                                end;
                                */
            end;
        }
        field(7; "Cost Of Training"; Decimal)
        {
            CalcFormula = sum("HR Training Cost".Cost where("Training Id" = field("Application No")));
            DecimalPlaces = 0 : 0;
            Editable = true;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                if Posted then begin
                    if Duration <> xRec.Duration then begin
                        Message('%1', 'You cannot change the costs after posting');
                        Duration := xRec.Duration;
                    end
                end
            end;
        }
        field(8; Location; Option)
        {
            Editable = true;
            OptionMembers = "Local",International;
        }
        field(11; Posted; Boolean)
        {
            Editable = true;
        }
        field(12; Description; Text[250])
        {
            Editable = true;
        }
        field(28; "Training Evaluation Results"; Option)
        {
            OptionMembers = "Not Evaluated",Passed,Failed;

            trigger OnValidate()
            begin
                if "Training Status" <> "training status"::"Completed Successfully" then
                    Error(mcontent4);
            end;
        }
        field(29; Year; Integer) { }
        field(30; Trainer; Code[20])
        {
            Editable = true;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", Trainer);
                if Vend.Find('-') then begin
                    "Training Institution" := Vend.Name;
                end;
            end;
        }
        field(31; "Purpose of Training"; Text[100]) { }
        field(32; Status; Option)
        {
            Editable = false;
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(33; "Employee No."; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if "Training Category" <> "training category"::Group then begin
                    HREmp.Get("Employee No.");
                    "Global Dimension 1" := HREmp."Global Dimension 1 Code";
                    "Global Dimension 2" := HREmp."Global Dimension 2 Code";
                    "Employee Name" := HREmp."Full Name";
                end;
            end;
        }
        field(35; "Application Date"; Date)
        {
            Editable = false;
        }
        field(36; "No. Series"; Code[10]) { }
        field(37; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(39; Recommendations; Code[20]) { }
        field(40; "User ID"; Code[50]) { }
        field(41; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(42; "Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            CaptionClass = '1,1,1';

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Global Dimension 1");
                if Dimn.Find('-') then begin
                    "Dim2 Name" := Dimn.Name;
                end;
            end;
        }
        field(43; "Employee Name"; Text[50]) { }
        field(44; "Training Institution"; Text[50]) { }
        field(45; "Training Category"; Option)
        {
            OptionCaption = 'Individual,Group';
            OptionMembers = Individual,Group;
        }
        field(46; "Table ID"; Integer) { }
        field(47; Supervisor; Code[50]) { }
        field(48; "Supervisor Name"; Text[100]) { }
        field(49; "Individual Course Code"; Code[50])
        {
            // TableRelation = "HR Training Courses"."Course Code" where("Individual Course" = const(Yes));
        }
        field(50; "Individual Course Description"; Text[250]) { }
        field(51; "No of Participants"; Integer)
        {
            CalcFormula = count("HR Training Participants" where("Training Code" = field("Application No")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields("No of Participants");
                if "No of Participants" > "No of Required Participants" then begin
                    Error('Nominated Participants cannot exceed the Number of Participants Required 1111111 ');
                end;
                if "No of Participants" <= 0 then begin
                    Error('Required positions cannot be Less Than or Equal to Zero');
                end;
            end;
        }
        field(50000; "Global Dimension 2"; Code[30])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Global Dimension 2");
                if Dimn.Find('-') then begin
                    "Dim2 Name" := Dimn.Name;
                end;


                /*
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.","Employee No.");
                HREmp.SETRANGE(HREmp."Department Code",Directorate);
                HREmp.SETRANGE(HREmp.Region,Department);
                IF HREmp.FIND() THEN BEGIN
                IF TranPart.GET("Application No")THEN BEGIN
                 TranPart.INIT;
                 TranPart."Employee Code":=HREmp."No.";
                 TranPart."Employee name":=HREmp."First Name"+'-'+HREmp."Middle Name"+'-'+HREmp."Last Name";
                 TranPart.INSERT;
                END;
                END;
                */

            end;
        }
        field(50001; "No of Required Participants"; Integer)
        {
            FieldClass = Normal;
        }
        field(50002; Station; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            CaptionClass = '1,3,2';

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, Station);
                if Dimn.Find('-') then begin
                    "Station Name" := Dimn.Name;
                end;
            end;
        }
        field(50003; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50004; "Quarter Offered"; Option)
        {
            OptionCaption = ' 1st Quarter,2nd Quarter,3rd Quarter';
            OptionMembers = " 1st Quarter","2nd Quarter","3rd Quarter";
        }
        field(50005; "Training Status"; Option)
        {
            OptionCaption = ' ,Suspended,Deferred,Cancelled,Completed Successfully';
            OptionMembers = " ",Suspended,Deferred,Cancelled,"Completed Successfully";

            trigger OnValidate()
            begin
                if Status <> Status::Approved then
                    Error(mcontent5);
            end;
        }
        field(50006; "Dim2 Name"; Text[50]) { }
        field(50007; "Station Name"; Text[50]) { }
        field(50008; "Dim1 Name"; Text[50]) { }
        field(50009; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(50010; Sponsor; Option)
        {
            OptionMembers = Self,KNCHR,Donor,Other;
        }
        field(50011; Specify; Text[80]) { }
        field(50012; Country; Code[20])
        {
            TableRelation = "Country/Region".Code;
        }
        field(50013; Region; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const(Region));
        }
        field(50014; "Is HOD"; Boolean) { }
    }

    keys
    {
        key(Key1; "Application No")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Course Title") { }
    }

    trigger OnDelete()
    begin
        if Status <> Status::New then
            Error(mcontent);
    end;

    trigger OnInsert()
    begin
        if "Application No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Training Application Nos.");
            "Application No" := NoSeriesMgt.GetNextNo(HRSetup."Training Application Nos.", 0D, true);
        end;

        "User ID" := UserId;
        "Application Date" := Today;

        "Table ID" := Database::"HR-Employee";
        "User ID" := UserId;

        if "Training Category" <> "training category"::Group then begin
            //TESTFIELD("Employee No.");
            if userseups.Get(UserId) then begin
                if userseups."Employee No." = '' then Error('Your Login is not associated with any employee. Consult the system Admin.');
                if HREmp.Get(userseups."Employee No.") then begin
                    "Employee No." := HREmp."No.";
                    "Employee Name" := HREmp."Full Name";
                    "Global Dimension 1" := HREmp."Global Dimension 1 Code";
                    "Global Dimension 2" := HREmp."Global Dimension 1 Code";
                    "User ID" := UserId;
                end else begin
                    Error('User Must be Setup as an employee first. Consult the HR Officer so as to be setup as an employee')
                end;

            end else
                Error('You are not a legitimate user! Consult the system Admin.');
        end;

        if UserSetup.Get(UserId) then begin
            Supervisor := UserSetup."Approver ID";
            UserSetup.Reset;
            if UserSetup.Get(Supervisor) then
                "Supervisor Name" := UserSetup."E-Mail";
        end;

        CalcFields("No of Participants");
        /*
        IF "No of Participants" > "No of Required Participants" THEN
        BEGIN
            ERROR('Nominated Participants cannot exceed the Number of Participants Required 1111111 ');
        END;
        IF "No of Participants" <= 0 THEN
        BEGIN
            ERROR('Required positions cannot be Less Than or Equal to Zero');
        END;
         */

    end;

    trigger OnModify()
    begin
        //CALCFIELDS("Occupied Positions");
        //IF "Occupied Positions">0 THEN
        //ERROR('Cannot modify job if it has occupants');
        //IF Status <> Status::New THEN
        //ERROR(mcontent2);
    end;

    var
        // HRTrainingNeeds: Record UnknownRecord70135161;
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        mcontent: label 'Status must be new on Training Application No.';
        HREmp: Record "HR-Employee";
        Vend: Record Vendor;
        UserSetup: Record "User Setup";
        // HRTrainApp: Record UnknownRecord70135114;
        // TranPart: Record UnknownRecord70135172;
        mcontent4: label 'You cannot evaluate a training which is not successfully completed.';
        mcontent5: label 'You cannot change training status if the status is not approved';
        Dimn: Record "Dimension Value";
        userseups: Record "User Setup";
}

