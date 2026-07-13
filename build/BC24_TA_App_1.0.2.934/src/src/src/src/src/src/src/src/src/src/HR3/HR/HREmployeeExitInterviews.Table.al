Table 50801 "HR Employee Exit Interviews"
{
    // DrillDownPageID = UnknownPage50035;
    // LookupPageID = UnknownPage50035;

    fields
    {
        field(1; "Exit Clearance No"; Code[20]) { }
        field(2; "Date Of Clearance"; Date)
        {

            trigger OnValidate()
            begin

                /* IF ("Date Of Interview" <> 0D) AND ("Date Of Interview" <> xRec."Date Of Interview") THEN BEGIN
                   CareerEvent.SetMessage('Exit Interview Conducted');
                   CareerEvent.RUNMODAL;
                   OK:= CareerEvent.ReturnResult;
                   IF OK THEN BEGIN
                       CareerHistory.INIT;
                       CareerHistory."Employee No.":= "Employee No.";
                       CareerHistory."Date Of Event":= "Date Of Interview";
                       CareerHistory."Career Event":= 'Exit Interview Conducted';
                       CareerHistory."Exit Interview":= TRUE;
                        OK:= Employee.GET("Employee No.");
                        IF OK THEN BEGIN
                         CareerHistory."Employee First Name":= Employee."Known As";
                         CareerHistory."Employee Last Name":= Employee."Last Name";
                        END;
                       CareerHistory.INSERT;
                    END;
                 END;
                   */

            end;
        }
        field(3; "Clearance Requester"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Clearance Requester");
                if HREmp.Find('-') then begin
                    IntFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Clearer Name" := IntFullName;
                    Title := hremp.Title;
                    job_id := HREmp."Job ID";
                    job_title := HREmp."Job Title";
                    Process := HREmp.Division;
                    Sector := HREmp.Sector;
                    "Branch Code" := HREmp."Global Dimension 1 Code";
                    "Department Code" := HREmp."Global Dimension 2 Code";
                end;
            end;
        }
        field(4; "Re Employ In Future"; Option)
        {
            OptionCaption = ' ,Yes,No,Not Applicable';
            OptionMembers = " ",Yes,No,"Not Applicable";
        }
        field(5; "Nature Of Separation"; Option)
        {
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Deceased,Termination,"Contract Ended",Abscondment,"Appt. Revoked","Contract Termination",Retrenchment,Other;
        }
        field(6; "Reason For Leaving (Other)"; Text[150]) { }
        field(7; "Date Of Leaving"; Date) { }
        field(8; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            var
                Dimn: Record "Dimension Value";
            begin

                // Dimn.SetRange(Dimn.Code, "Directorate Code");
                // if Dimn.Find('-') then begin
                //     "Directorate Name" := Dimn.Name;
                // end;
            end;
        }
        field(9; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            var
                Dimn: Record "Dimension Value";
            begin

                // Dimn.SetRange(Dimn.Code, "Department Code");
                // if Dimn.Find('-') then begin
                //     "Department Name" := Dimn.Name;
                // end;
            end;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = exist("HR Human Resource Comments" where("Table Name" = const("Exit Interviews"),
                                                                    "No." = field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee No.");
                if HREmp.Find('-') then begin
                    EmpFullName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Employee Name" := EmpFullName;
                end;
            end;
        }
        field(12; "No Series"; Code[10]) { }
        field(13; "Form Submitted"; Boolean)
        {

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange("No.", "Employee No.");
                OK := HREmp.Find('-');

                if "Form Submitted" = true then begin

                    if OK then begin
                        HREmp.Status := HREmp.Status::Active;
                        HREmp."Date Of Leaving" := "Date Of Leaving";
                        // HREmp."Nature Of Separation":= "Nature Of Separation";
                        HREmp."Exit Interview Done by" := "Clearance Requester";
                        HREmp.Modify;
                    end
                end;

                if "Form Submitted" = false then begin
                    if OK then begin
                        HREmp.Status := HREmp.Status::Active;
                        HREmp."Date Of Leaving" := 0D;
                        HREmp."Termination Category" := HREmp."termination category"::" ";
                        HREmp."Exit Interview Done by" := '';
                        HREmp.Modify;
                    end;
                end;
            end;
        }
        field(15; "Employee Name"; Text[50]) { }
        field(16; "Clearer Name"; Text[50]) { }
        field(17; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved';
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = 'Branch Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            Editable = false;
            trigger OnValidate()
            begin

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 3 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 3 Name" := DimVal.Name;
            end;
        }
        field(800; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = 'Branch Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;
            trigger OnValidate()
            begin

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 3 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 3 Name" := DimVal.Name;
            end;
        }

        field(805; Process; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            Editable = false;
            trigger OnValidate()
            begin

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 5 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 5 Name" := DimVal.Name;
            end;
        }
        field(806; Sector; code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            Editable = false;
            trigger OnValidate()
            begin

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Global Dimension 4 Code");
                // if DimVal.Find('-') then
                //     "Global Dimension 4 Name" := DimVal.Name;
            end;
        }
        field(50000; "Station Name"; Text[100])
        {
            Editable = false;
        }
        field(50001; "Directorate Name"; Text[100])
        {
            Editable = false;
        }
        field(50002; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(50003; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50004; "Station Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50005; "Directorate Filter"; Code[20]) { }
        field(50006; "Employee Type"; Option)
        {
            OptionCaption = 'Permanent,Casuals,Contract';
            OptionMembers = Permanent,Casuals,Contract;
        }
        field(50007; "Appointment Date"; Date) { }
        field(5008; Title; option)
        {
            OptionMembers = " ",Mr,Mrs,Miss,Ms,"Dr."," Eng. ",Prof;
        }
        field(5009; job_id; code[20]) { }
        field(5010; job_title; text[50]) { }
    }

    keys
    {
        key(Key1; "Exit Clearance No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

        //GENERATE NEW NUMBER FOR THE DOCUMENT
        if "Exit Clearance No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Exit Interview Nos");
            "Exit Clearance No" := NoSeriesMgt.GetNextNo(HRSetup."Exit Interview Nos", 0D, true);
        end;


        "Clearance Requester" := UserId;
    end;

    var
        //  CareerEvent: Page UnknownPage70135475;
        OK: Boolean;
        HREmp: Record "HR-Employee";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        EmpFullName: Text;
        IntFullName: Text;
}

