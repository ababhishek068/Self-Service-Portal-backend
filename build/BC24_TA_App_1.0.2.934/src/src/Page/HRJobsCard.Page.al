Page 50321 "HR Jobs Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job,Job Succession';
    SourceTable = "HR Jobs";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(JobID; Rec."Job ID")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(Id;Id){}
                field(JobTitle; Rec."Job Description")
                {
                    Caption = 'Job Title';
                    ToolTip = 'Specifies the value of the Job Title field.';
                }

                field("Job Family Code";"Job Family Code")
                {
                    ApplicationArea = all;

                }
                field("Job Family Description";"Job Family Description")
                {

                    ApplicationArea = all;
                }
                field("Job Sub-Family Code";"Job Sub-Family Code")
                {
                ApplicationArea = all;
                }
                field("Job sub-Family Desc";"Job sub-Family Desc")
                {
                   ApplicationArea = all; 
                }
                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grade field.';

                }
                // field("Supervisor/Manager"; "Supervisor/Manager")
                // {
                //     ApplicationArea = all;
                // }

                field("Position Reporting to"; Rec."Position Reporting to")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Position Reporting to field.';

                    trigger OnValidate()
                    var
                        HRJobs: Record "HR Jobs";
                    begin
                        Rec."Position Report to Description" := '';

                        HRJobs.Get(Rec."Position Reporting to");
                        Rec."Position Report to Description" := HRJobs."Job Description";
                    end;


                }

                field("Position Report to Description"; Rec."Position Report to Description")
                {
                    ToolTip = 'Specifies the value of the Position Report to Description field.';

                }
                field("Position Reporting to2"; Rec."Position Reporting to2")
                {
                    ApplicationArea = all;
                    caption = 'Administrative Position Reporting To';
                    ToolTip = 'Specifies the value of the Administrative Position Reporting To field.';

                    trigger OnValidate()
                    begin

                    end;


                }
                field("Jobs Reporting To"; Rec."Jobs Reporting To")
                {
                    Editable = false;
                    caption = 'No. of Jobs Reporting To';
                    ToolTip = 'Specifies the value of the No. of Jobs Reporting To field.';
                }


                field("Approved In Posts"; Rec."No of Posts")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the No of Posts field.';
                }

                field(OccupiedPositions; Rec."Occupied Positions")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Occupied Positions field.';
                }

                field(VacantPositions; Rec."Vacant Positions")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Vacant Positions field.';
                }

                field("Directorate Code"; Rec."Directorate Code")
                {
                    ToolTip = 'Specifies the value of the Directorate Code field.';
                }

                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }

                field("Job Cadre"; Rec."Job Cadre")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Cadre field.';
                }
                field("Occupied Positions (M)"; Rec."Occupied Positions (M)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Occupied Positions (M) field.';
                }
                field("Occupied Positions (F)"; Rec."Occupied Positions (F)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Occupied Positions (F) field.';
                }

                field(Status; Rec.Status)
                {
                    Style = Attention;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }

        }
        area(factboxes)
        {

            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID);
                end;
            }

            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Enabled = true;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = true;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }

            group(Job)
            {
                Caption = 'Job';
                action("Raise Requisition")
                {
                    Caption = 'Raise Requisition';
                    Image = Job;
                    ApplicationArea = basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HR Employee Requisition Card";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    RunPageOnRec = false;
                    ToolTip = 'Executes the Raise Requisition action.';

                    trigger OnAction()
                    begin
                        CurrPage.Close;
                    end;
                }
                action(Occupants)
                {
                    Caption = 'Occupants';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = basic;
                    RunObject = Page "HR Job Occupants";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    ToolTip = 'Executes the Occupants action.';
                }

                action(Requirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requirements';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HR Job Requirement Lines";
                    RunPageLink = "Job Id" = field("Job ID");
                    ToolTip = 'Executes the Requirements action.';
                }
                action("Job Responsibilities")
                {
                    Caption = 'Job Responsibilities';
                    Image = Category;
                    Promoted = true;
                    ApplicationArea = basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Job Responsibilities";
                    RunPageLink = "Job ID" = field("Job ID");
                    Visible = true;
                    ToolTip = 'Executes the Job Responsibilities action.';
                }
                //  action("Job Supervisor")
                // {
                //     Caption = 'Position Supervisor';
                //     Image = Category;
                //     Promoted = true;
                //     ApplicationArea = basic;
                //     PromotedCategory = Process;
                //     RunObject = Page "Position Supervised";
                //     RunPageLink = "Job ID" = field("Job ID");
                //     Visible = true;
                // }
                action("Job RelationShip")
                {
                    Caption = 'Job Working Relationship';
                    Image = Category;
                    Promoted = true;
                    ApplicationArea = basic;
                    PromotedCategory = Process;
                    RunObject = Page "Job Working Relationships";
                    RunPageLink = "Job ID" = field("Job ID");
                    Visible = true;
                    ToolTip = 'Executes the Job Working Relationship action.';
                }
            }

        }

    }

    trigger OnAfterGetCurrRecord()
    begin

        UpdateControls;
    end;

    trigger OnOpenPage()
    begin

        UpdateControls;
    end;

    var
    //HREmployees: Record "HR-Employee";
    // HRCodeunit: Codeunit "HR Codeunit";

    local procedure UpdateControls()
    begin
        //CurrPage.Editable := HRCodeunit.fn_UpdateControls(Format(Status));
    end;

}

