Table 50618 "HR Training Courses"
{
    DrillDownPageID = "HR Course List";
    LookupPageID = "HR Course List";

    fields
    {
        field(1; "Course Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Course Tittle"; Text[200]) { }
        field(3; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if (Duration <> 0) and ("Start Date" <> 0D) then
                    //"Return Date" := DetermineLeaveReturnDate("Start Date","Days Applied");
                    //"End Date" := DeterminethisLeaveEndDate("Return Date");
                    "End Date" := HRLeaveApp.CalcEndDate("Start Date", Duration);
                Modify;
            end;
        }
        field(4; "End Date"; Date) { }
        field(5; "Duration Units"; Option)
        {
            OptionMembers = Hours,Days,Weeks,Months,Years;
        }
        field(6; Duration; Decimal)
        {

            trigger OnValidate()
            begin
                begin
                    if (Duration <> 0) and ("Start Date" <> 0D) then
                        //"Return Date" := DetermineLeaveReturnDate("Start Date","Days Applied");
                        //"End Date" := DeterminethisLeaveEndDate("Return Date");
                        "End Date" := HRLeaveApp.CalcEndDate("Start Date", Duration);
                    Modify;
                end;
            end;
        }
        field(7; "Cost Of Training"; Decimal)
        {

            trigger OnValidate()
            begin
                /*IF Posted THEN BEGIN
                IF Duration <> xRec.Duration THEN BEGIN
                MESSAGE('%1','You cannot change the costs after posting');
                Duration := xRec.Duration;
                END
                END
                */

            end;
        }
        field(8; Location; Text[100]) { }
        field(10; "Re-Assessment Date"; Date) { }
        field(12; "Need Source"; Option)
        {
            OptionCaption = 'Appraisal,Succesion,Training,Employee,Employee Skill Plan';
            OptionMembers = Appraisal,Succesion,Training,Employee,"Employee Skill Plan";
        }
        field(13; Provider; Code[20])
        {
            Description = 'Stores Institutions for offering training';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", Provider);
                if Vend.Find('-') then begin
                    "Provider Name" := Vend.Name;
                end;
            end;
        }
        field(15; Posted; Boolean)
        {
            Editable = false;
        }
        field(16; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Campus Code");
                if Dimn.Find('-') then begin
                    "Campus Name" := Dimn.Name;
                end;
            end;
        }
        field(17; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, Department);
                if Dimn.Find('-') then begin
                    "Department Name" := Dimn.Name;
                end;
            end;
        }
        field(18; Closed; Boolean)
        {
            Editable = false;
        }
        field(19; "Qualification Code"; Code[20])
        {
            TableRelation = "HR Qualifications".Code where("Qualification Type" = field("Qualification Type"));

            trigger OnValidate()
            begin
                HRQualifications.SetRange(HRQualifications.Code, "Qualification Code");
                if HRQualifications.Find('-') then
                    "Qualification Description" := HRQualifications.Description;
            end;
        }
        field(20; "Qualification Type"; Code[30])
        {
            NotBlank = true;
            TableRelation = "HR Lookup Values".Code where(Type = const("Qualification Type"));
        }
        field(21; "Qualification Description"; Text[80]) { }
        field(22; "Training Applicants"; Integer)
        {
            CalcFormula = count("HR Training Applications" where("Course Title" = field("Course Code")));
            FieldClass = FlowField;
        }
        field(23; "Training Applicants (Passed)"; Integer)
        {
            CalcFormula = count("HR Training Applications" where("Course Title" = field("Course Code"),
                                                                  "Training Evaluation Results" = const(Passed)));
            FieldClass = FlowField;
        }
        field(24; "Training Applicants (Failed)"; Integer)
        {
            CalcFormula = count("HR Training Applications" where("Course Title" = field("Course Code"),
                                                                  "Training Evaluation Results" = const(Failed)));
            FieldClass = FlowField;
        }
        field(25; "Provider Name"; Text[50]) { }
        field(26; "No of Participants Required"; Integer) { }
        field(27; "Nature of Training"; Option)
        {
            OptionCaption = ' ,Internal,External,Self,E-Learning';
            OptionMembers = " ",Internal,External,Self,"E-Learning";
        }
        field(28; "Training Type"; Option)
        {
            OptionCaption = ',Long course,Short Course,Seminar,Workshop';
            OptionMembers = ,"Long course","Short Course",Seminar,Workshop;
        }
        field(29; "Course Version"; Code[20]) { }
        field(30; "Course Version Description"; Text[200]) { }
        field(31; "Individual Course"; Boolean) { }
        field(32; "Closing Status"; Option)
        {
            OptionCaption = ' ,Suspended,Deferred,Cancelled,Completed Successfully';
            OptionMembers = " ",Suspended,Deferred,Cancelled,"Completed Successfully";
        }
        field(33; "Quarter Offered"; Option)
        {
            OptionCaption = ' 1st Quarter,2nd Quarter,3rd Quarter';
            OptionMembers = " 1st Quarter","2nd Quarter","3rd Quarter";
        }
        field(50000; "Campus Name"; Text[100])
        {
            Editable = false;
        }
        field(50001; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(50002; "Station Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin

                Dimn.SetRange(Dimn.Code, Department);
                if Dimn.Find('-') then begin
                    "Station Name" := Dimn.Name;
                end;
            end;
        }
        field(50003; "Station Name"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Course Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Course Code", "Course Tittle") { }
    }

    var
        HRLeaveApp: Record "HR Leave Requisition";
        HRQualifications: Record "HR Qualifications";
        Vend: Record Vendor;
        Dimn: Record "Dimension Value";
}

