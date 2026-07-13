Table 50693 "HR Jobs"
{
    DrillDownPageId = "HR Jobs List";
    LookupPageId = "HR Jobs List";

    fields
    {
        field(1; "Job ID"; Code[25]) { }
        field(2; "Job Description"; Text[250])
        {
            Editable = true;
           
            trigger OnValidate()
             var
            quer:Boolean;
            hrsetup: Record "HR Setup";
            begin
                TestField("Job ID");
                if "Job Description"<>'' then  begin
                    hrsetup.Reset();
                    hrsetup.SetRange(hrsetup."Monitor Job updates",true);
                    if hrsetup.FindFirst() then begin
                    quer:=Confirm('Is this (a) Title change or (b) correction? If  (a) click [ok]');
                    if quer=true then begin

                        PostPromotion(Rec);
                        updatehr(Rec);
                    end else if quer=false then begin
                        updatehr(Rec);                      

                end;
                end;

                end;

                
            end;

            
        }
        field(3; "No of Posts"; Integer)
        {

            trigger OnValidate()
            begin
                CalcFields("Occupied Positions");
                Clear("Vacant Positions");
                if "Occupied Positions" <= "No of Posts" then
                    "Vacant Positions" := "No of Posts" - "Occupied Positions"
                else
                    "Vacant Positions" := 0;
            end;
        }
        field(4; "Position Reporting to"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" where(Status = const(Approved));
            trigger OnValidate()
            var
            hrjobs: Record "HR Jobs";
            k: Boolean;
            hrsetup:Record "HR Setup";
            begin
                hrsetup.Reset();
                    hrsetup.SetRange(hrsetup."Monitor Job updates",true);
                    if hrsetup.FindFirst() then begin

                k:=Confirm('Do you wish to update all jobs reporting to the replaced reporting to?');
                if k=true then begin
                    hrjobs.Reset();
                    hrjobs.SetRange(hrjobs."Jobs Reporting To","Jobs Reporting To");
                    if hrjobs.find('-') then begin
                        repeat
                        hrjobs."Jobs Reporting To":="Jobs Reporting To";
                        until hrjobs.next=0;

                    end; 
                end;                   

                end;

                
            end;
        }
        field(409; "Position Reporting to2"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" where(Status = const(Approved));
        }
        field(5; "Occupied Positions"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Vacant Positions"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                //"Vacant Positions" := "No of Posts" - "Occupied Positions";
            end;
        }
        field(7; "Score code"; Code[20]) { }
        field(8; "Directorate Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Directorate Code");
                if Dimn.Find('-') then begin
                    "Directorate Name" := Dimn.Name;
                end;
            end;
        }

        field(9; "Department Code"; Code[20])
        {
            CaptionClass = 'Department';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));


            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Department Code");
                if Dimn.Find('-') then begin
                    "Department Name" := Dimn.Name;
                end;
            end;
        }
        field(17; "Total Score"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(19; "Main Objective"; Text[250]) { }
        field(21; "Key Position"; Boolean) { }
        field(22; Category; Code[20]) { }
        field(23; "Job Grade"; Code[20])
        {
            TableRelation = "Sal Grades"."Salary Grade";
        }

        field(24; "Employee Requisitions"; Integer)
        {
            CalcFormula = count("HR Employee Requisitions" where("Job ID" = field("Job ID")));
            FieldClass = FlowField;
        }
        field(27; UserID; Code[50]) { }
        field(240; "Position Report to Description"; Code[100])
        {
            DataClassification = ToBeClassified;
        }

        field(28; "Supervisor/Manager"; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            begin
                HREmp.Get("Supervisor/Manager");
                "Supervisor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(29; "Supervisor Name"; Text[30])
        {
            Editable = false;
        }
        field(30; Status; Option)
        {
            //Editable = false;
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(31; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(32; "Date Created"; Date) { }
        field(33; "No. of Requirements"; Integer)
        {
            CalcFormula = count("HR Jobs Requirements" where("Job ID" = field("Job ID")));
            FieldClass = FlowField;
        }
        field(34; "No. of Responsibilities"; Integer)
        {
            CalcFormula = count("Employee Responsibility" where("Responsibility Description" = field("Job ID")));
            FieldClass = FlowField;
        }
        field(35; "Reason for Job creation"; Text[200]) { }
        field(36; "Memo Ref No."; Code[100]) { }
        field(37; "Memo Approval Date"; Date) { }
        field(38; "Station Code"; Code[20])
        {
            Caption = 'Section Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(0));

            trigger OnValidate()
            begin
                Dimn.SetRange(Dimn.Code, "Station Code");
                if Dimn.Find('-') then begin
                    "Station Name" := Dimn.Name;
                end;
            end;
        }
        field(39; "Job Family Code"; code[20])
        {
            Caption = 'Job Family Code';
            TableRelation = "Job Family";
            trigger OnValidate()
            begin
                jobfam.Reset();
                jobfam.SetRange(jobfam."Job Family Code", "Job Family Code");
                if jobfam.FindFirst() then begin
                    "Job Family Description" := jobfam."Job Family Description";
                end;
            end;

        }
        field(40; "Job Family Description"; text[50])
        {
            Caption = 'Job Family Description';
            Editable = false;
        }
        field(41; "Job Sub-Family Code"; code[20])
        {

            Caption = 'Job sub-Family Code';
            TableRelation = "Job Sub Family";
            trigger OnValidate()
            begin
                //testfield("job family code");
                jobsubfam.Reset();
                jobsubfam.SetRange(jobsubfam."Job Family Sub-Family", "Job Sub-Family Code");
                if jobsubfam.FindFirst() then begin
                    "Job sub-Family Desc" := jobsubfam."Job Family Sub-Family Desc";
                end;
            end;

        }
        field(42; "Job sub-Family Desc"; text[50])
        {
            Caption = 'Job sub-Family Description';
            Editable = false;
        }
        field(50000; "Station Name"; Text[100])
        {
            Caption = 'Section Name';
            Editable = false;
        }
        field(50001; "Directorate Name"; Text[100])
        {
            Caption = 'Campus Name';
            Editable = false;
        }
        field(50002; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(50003; "Employment Category"; Code[20])
        {
            TableRelation = "Employee Categories".Code;
        }
        field(50004; "Employment Grade"; Code[20])
        {
            TableRelation = "Job_Salary grade/steps"."Salary Grade code" where("Employee Category" = field("Employment Category"));

            trigger OnValidate()
            begin
                "Job Grade" := "Employment Grade";
            end;
        }
        field(50005; "Occupied Positions (F)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(active),
                                                     Gender = filter(Female)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Occupied Positions (M)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(active),
                                                     Gender = filter(Male)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Occupied Positions FullTim (F)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(Active),
                                                     Gender = filter(Female)));

            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Occupied Positions FullTim (M)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(Active),
                                                     Gender = filter(Male)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Occupied Positions PartTim (F)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(Active),
                                                     Gender = filter(Female)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Occupied Positions PartTim (M)"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Job ID" = field("Job ID"),
                                                     Status = filter(Active),
                                                     Gender = filter(Male)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; Division; Code[20])
        {
            CalcFormula = lookup("Dimension Value".Code where(Code = field("Department Code")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50012; "Basic Salary"; Decimal) { }
        field(50013; "House Allowance"; Decimal) { }
        field(50014; "Salary Scale From"; Decimal) { }
        field(50015; "Salary Scale To"; Decimal) { }
        field(50016; "Medical Insurance Cover IN"; Decimal) { }
        field(50017; "Medical Insurance Cover OUT"; Decimal) { }
        field(50018; "Type Of Contract"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Contract Type"));
        }
        field(50019; "No. Series"; code[20]) { }
        field(50020; "PSC Job Grade"; code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("PSC Grade"));
        }
        field(50021; "Job Cadre"; code[20])
        {
            Caption = 'Team Leader/Special Assignment';
            TableRelation = "HR Job Cader".code;
        }
        field(50022; "Jobs Reporting To"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("HR Jobs" where("Position Reporting to" = field("Job ID")));
        }
        field(5003; Id; Integer) { }


    }

    keys
    {
        key(Key1; "Job ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job Description") { }
    }

    trigger OnDelete()
    begin
        /*
         CALCFIELDS("Occupied Positions");
         IF "Occupied Positions">0 THEN
         ERROR('Cannot delete job if it has occupants');
          */

    end;

    trigger OnInsert()
    var
        GenLedgerSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        UserID := UserID;
        "Date Created" := Today;

        if "Job ID" = '' then begin

            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Job ID");

            //NoSeriesMgt.GetNextNo(GenLedgerSetup."Job ID", xRec."No. Series", 0D, "Job ID", "No. Series");
            "Job ID" := NoSeriesMgt.GetNextNo(GenLedgerSetup."Job ID", 0D, true);
        end;



    END;



    trigger OnModify()
    begin
        /* CALCFIELDS("Occupied Positions");
         IF "Occupied Positions">0 THEN
         ERROR('Cannot modify job if it has occupants');
        */
        //PostPromotion(Rec)


    end;
    


    var
        HREmp: Record "HR-Employee";
        Dimn: Record "Dimension Value";
        jobfam: Record "Job Family";
        jobsubfam: Record "Job Sub Family";

        local procedure PostPromotion(Rec: Record "HR Jobs")
    var
        internalpromotion: Record "Internal Employment History";
    begin 
           HREmp.Reset();
           HREmp.SetRange(HREmp."Job ID","Job ID");
           HREmp.SetRange(HREmp.Status,HREmp.Status::Active);
           if HREmp.Find('-') then begin 
            repeat       
            internalpromotion.Init();
            internalpromotion.Promotion_No := HREmp."No.";
            internalpromotion.current := true;
            internalpromotion.Validate(current);
            internalpromotion.From := Today;
            internalpromotion."Employee No." := HREmp."No.";
            internalpromotion."Job ID":="Job ID";
            HREmp.Validate("Job ID");
            internalpromotion."Job Title":="Job Description";
            //internalpromotion.Status := Rec.Status;
            internalpromotion."Reason for Change" := internalpromotion."Reason for Change"::"Temporary Position";
            internalpromotion."Reason Description" := 'Job Position renaming';
            internalpromotion.Comment := 'Job Position renaming';          
            internalpromotion.Insert;
        until HREmp.next=0;
           end;
        //Error('Procedure PostPromotion not implemented.');

    end;
 procedure updatehr(Rec: Record "HR Jobs")
 begin
                    HREmp.Reset();
                    HREmp.SetRange(HREmp."Job ID","Job ID");
                    HREmp.SetRange(HREmp.Status,HREmp.Status::Active);
                    if HREmp.Find('-') then begin
                        repeat
                        HREmp."Job Title":="Job Description";
                        HREmp.Modify;
                        Until  HREmp.next=0;          
                         
                    end;
end;

                 


}

