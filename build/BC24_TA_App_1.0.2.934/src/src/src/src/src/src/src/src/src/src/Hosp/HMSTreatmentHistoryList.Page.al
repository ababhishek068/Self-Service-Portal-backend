page 51296 "HMS Treatment History List"
{
    CardPageID = "HMS Treatment Form History";
    Editable = false;
    PageType = List;
    SourceTable = "HMS Treatment Form Header";
    SourceTableView = WHERE(Status = CONST(Completed));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                ShowCaption = false;
                field("Treatment No."; Rec."Treatment No.")
                {
                    Caption = 'Treatment No.';
                    ToolTip = 'Specifies the value of the Treatment No. field.';
                }
                field("Treatment Location"; Rec."Treatment Location")
                {
                    ToolTip = 'Specifies the value of the Treatment Location field.';
                }
                field("Treatment Type"; Rec."Treatment Type")
                {
                    ToolTip = 'Specifies the value of the Treatment Type field.';
                }
                field(Direct; Rec.Direct)
                {
                    ToolTip = 'Specifies the value of the Direct field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field("Treatment Date"; Rec."Treatment Date")
                {
                    ToolTip = 'Specifies the value of the Treatment Date field.';
                }
                field("Treatment Time"; Rec."Treatment Time")
                {
                    ToolTip = 'Specifies the value of the Treatment Time field.';
                }
                field("Doctor ID"; Rec."Doctor ID")
                {
                    ToolTip = 'Specifies the value of the Doctor ID field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ToolTip = 'Specifies the value of the Patient Name field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student/Emp/Rel No. field.';
                }

                field("Employee No."; Rec."Employee No.")
                {
                    Caption = 'PF No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PF No. field.';
                }
                field("Employee No.2"; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("&Treatment Details")
            {
                Caption = '&Treatment Details';
                Image = Ledger;
                action(Processes)
                {
                    Caption = 'Processes';
                    Image = Production;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Processes";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Processes action.';
                }
                action(Signs)
                {
                    Caption = 'Signs';
                    Image = RegisteredDocs;
                    Promoted = true;
                    RunObject = Page "HMS Observation Signs";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Signs action.';
                }
                action(Symptoms)
                {
                    Caption = 'Symptoms';
                    Image = RegisterPick;
                    Promoted = true;
                    RunObject = Page "HMS Observation Symptoms";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Symptoms action.';
                }

                action("Laboratory Needs")
                {
                    Caption = 'Laboratory Needs';
                    Image = TestFile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Laboratory";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Laboratory Needs action.';
                }
                action("Radiology Needs")
                {
                    Caption = 'Radiology Needs';
                    Image = ReleaseShipment;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Radiology";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Radiology Needs action.';
                }
                action(Diagmnosis)
                {
                    Caption = 'Diagmnosis';
                    Image = AnalysisView;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Diagnosis";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Diagmnosis action.';
                }
                action(Injections)
                {
                    Caption = 'Injections';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Injection";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Injections action.';
                }
                action(Prescriptions)
                {
                    Caption = 'Prescriptions';
                    Image = ItemAvailability;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Drug";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Prescriptions action.';
                }
                action(Referrals)
                {
                    Caption = 'Referrals';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Referral";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Referrals action.';
                }
                action(Admissions)
                {
                    Caption = 'Admissions';
                    Image = Account;
                    Promoted = true;
                    RunObject = Page "HMS Treatment Form Admission";
                    RunPageLink = "Treatment No." = FIELD("Treatment No.");
                    ToolTip = 'Executes the Admissions action.';
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

