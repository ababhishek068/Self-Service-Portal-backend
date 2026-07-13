Table 50332 "HR Appraisal Header - UP"
{
    DrillDownPageID = "HR Appraisal Header List - DD";
    LookupPageID = "HR Appraisal Header List - DD";

    fields
    {


        
        field(1; "Appraisal No"; Code[30])
        {
            DataClassification = ToBeClassified;
            
        }
        field(2; "Supervisor User ID."; Code[20])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(3; "Appraisal Type"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Appraisal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "HR Appraisal Periods - UP".Code;
            trigger OnValidate()
            var
                ApprEvalLines: Record "Appraisal Evaluation Lines";
                IndWorkPlanLines: Record "Individual Target Activities";
                LineNo: Integer;
            begin
                TestField("Employee No.");

                LineNo := 1;
                ApprEvalLines.Reset();
                ApprEvalLines.SetRange("Appraisal Code", "Appraisal No");
                if ApprEvalLines.Find('-') then ApprEvalLines.DeleteAll();

                IndWorkPlanLines.Reset();
                IndWorkPlanLines.SetRange("Staff No", "Employee No.");
                IndWorkPlanLines.SetRange("Appraisal Period", "Appraisal Period");
                if IndWorkPlanLines.Find('-') then begin
                    repeat
                        ApprEvalLines.Init();
                        ApprEvalLines."Appraisal Code" := "Appraisal No";
                        ApprEvalLines."Staff No" := "Employee No.";
                        ApprEvalLines."Appraisal Period" := "Appraisal Period";
                        ApprEvalLines.Objective := IndWorkPlanLines.Objective;
                        ApprEvalLines.Target := IndWorkPlanLines.Target;
                        ApprEvalLines.Activity := IndWorkPlanLines.Activity;
                        ApprEvalLines."Resources Required" := IndWorkPlanLines."Resources Required";
                        ApprEvalLines."Expected Results" := IndWorkPlanLines."Expected Results";
                        ApprEvalLines."Time Frame" := IndWorkPlanLines."Time Frame";
                        ApprEvalLines."Performance Indicator" := IndWorkPlanLines."Performance Indicator";
                        ApprEvalLines."Entry No" := LineNo;
                        ApprEvalLines.Insert();
                        LineNo := LineNo + 1;
                    until IndWorkPlanLines.Next() = 0;
                end;
            end;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionMembers = Appraisee,Supervisor,Closed;
        }
        field(6; Recommendations; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Appraisal Stage"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Target Setting","Target Approval","Mid Year Review","End Year Evalauation";
        }
        field(9; Sent; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Appraisee,Supervisor,Completed,Rated';
            OptionMembers = Appraisee,Supervisor,Completed,Rated;
        }
        field(10; "User ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(11; Picture; Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(12; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                /*clear(hremp);
                HREmp.SETRANGE(HREmp."No.","Employee No");
                IF HREmp.FINDFIRST() THEN
                BEGIN
                   "Employee Name":=HREmp."First Name"+' '+HREmp."Middle Name"+' '+HREmp."Last Name";
                //    Department:=;
                   "Job Title":=HREmp."Job Title";
                  //  Gender:=HREmp.Gender;
                   "Date of Employment":=HREmp."Date Of Join";*/

                //END;}

            end;
        }
        field(13; "Employee Name"; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Date of First Appointment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Designation; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50000; "Pay Grade / Job Group"; text[100]) { }

        field(50001; "Basic Salary"; text[100])
        {
            Caption = 'Basic salary (PM)';
        }
        field(50002; "Acting Appoint"; text[100])
        {
            Caption = 'Acting Appointment / Special Duty';
        }

        field(50003; "WEF"; Date)
        {
            Caption = 'With Effect from Date';
        }

        field(50004; "Terms of service"; Code[50])
        {
            TableRelation = "HR Lookup Values" where(Type = const("Contract Type"));
        }
        field(17; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear("Department Name");

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Department Code");
                if DimensionValue.FindFirst() then "Department Name" := DimensionValue.Name;
            end;
        }
        field(18; "Department Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(19; "Comments Appraisee"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Comments Appraiser"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Appraisal Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Evaluation Period Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Evaluation Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Target Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Company Targets,Individual Targets,Peer Targets,Surbodinates Targets,Out Agencies Targets,Company Rating,Individual Rating,Peer Rating,Surbodinates Rating,Out Agencies Rating';
            OptionMembers = " ","Company Targets","Individual Targets","Peer Targets","Surbodinates Targets","Out Agencies Targets","Company Rating","Individual Rating","Peer Rating","Surbodinates Rating","Out Agencies Rating";
        }

        field(50009; "Last Date of Promotion"; Date) { }
        field(25; "Supervisor No."; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                Emp: Record "HR-Employee";
            begin
                if Emp.Get("Supervisor No.") then "Supervisor Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
            end;
        }

        field(29; "Rating Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Locked; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Supervisor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Appraisal No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
    end;

    trigger OnInsert()
    var
        HRAppPeriod: Record "HR Appraisal Periods - UP";
        HREmp: Record "HR-Employee";
        HREmp_2: Record "HR-Employee";
        TheTable: Record "HR Appraisal Header - UP";

    begin
        if "Appraisal No" = '' then begin
            TheTable.Reset;
            if TheTable.FindLast then begin
                "Appraisal No" := IncStr(TheTable."Appraisal No")
            end else begin
                "Appraisal No" := 'APP-00001';
            end;
        end;

        "Appraisal Date" := Today;

        if "Employee No." = '' then begin
            HREmp.Reset();
            HREmp.SetRange(HREmp."User ID", UserId);
            HREmp.FindFirst();
            begin
                HREmp.TestField("Date Of Joining the Company");
                HREmp.TestField("Job Title");
                HREmp.TestField("Global Dimension 1 Code");
                //HREmp.TESTFIELD("Global Dimension 2 Code");
                HREmp.TestField("User ID");
                //HREmp.TestField("Manager No.");

                "Employee No." := HREmp."No.";
                "Employee Name" := HREmp."Full Name";
                "Date of First Appointment" := HREmp."Date Of Joining the Company";
                Designation := HREmp."Job Title";

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, HREmp."Global Dimension 1 Code");
                if DimensionValue.FindFirst() then begin
                    "Department Code" := UpperCase(DimensionValue.Code);
                    "Department Name" := UpperCase(DimensionValue.Name);
                end;

                "User ID" := HREmp."User ID";
                ///"Supervisor No." := HREmp."Manager No.";

                HREmp_2.Reset;
                HREmp_2.SetRange(HREmp_2."No.", "Supervisor No.");
                if HREmp_2.FindFirst then begin
                    "Supervisor User ID." := HREmp_2."User ID";
                    "Supervisor Name" := HREmp_2."Full Name";
                end;
                "E-mail" := HREmp."Company E-Mail";
            end;

            HRAppPeriod.Reset();
            HRAppPeriod.SetRange(Open, true);
            HRAppPeriod.FindFirst();
            begin
                HRAppPeriod.TestField("Period Start Date");
                HRAppPeriod.TestField("Period End Date");

                "Evaluation Period Start Date" := HRAppPeriod."Period Start Date";
                "Evaluation Period End Date" := HRAppPeriod."Period End Date";
                "Appraisal Period" := HRAppPeriod.Code;
            end;
        end;

    end;

    var
        DimensionValue: Record "Dimension Value";
}

