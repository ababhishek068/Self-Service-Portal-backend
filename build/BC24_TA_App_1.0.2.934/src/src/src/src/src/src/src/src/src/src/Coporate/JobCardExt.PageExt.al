pageextension 50050 "Job Card Ext" extends "Job Card"
{
    Caption = 'Project Card';
    layout
    {
         addbefore(Description)
         {
            field("Project Title";"Project Title")
            {
                ApplicationArea=basic;
            }
            field(Programme; Rec.Programme)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
         }

        addafter("No.")
        {
            field("Workplan No"; Rec."Workplan No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Workplan No field.';
                Visible=false;
            }
            field("Workplan Activity Code"; Rec."Workplan Activity Code")
            {
                Caption = 'Project Code';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Project Code field.';
                Visible=false;
            }
            field("Type of Project"; Rec."Type of Project")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Type of Project field.';
                Visible=false;
                trigger OnValidate()
                begin
                    if Rec."Type of Project" = Rec."Type of Project"::Research then begin
                        isVisibleResearch := true;
                        CurrPage.Update();
                    end;
                    if Rec."Type of Project" = Rec."Type of Project"::Development then begin
                        isVisibleDevelopment := true;
                        CurrPage.Update();
                    end;
                end;
            }
            field("Source of Funds"; Rec."Source of Funds")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Source of Funds field.';
            }
            field("Project Objective"; Rec."Project Objective")
            {
                ApplicationArea = basic;
                Visible=false;
                ToolTip = 'Specifies the name of the contact person at the customer who pays for the job.';
            }


        }


        addafter(General)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Global Dimension 3 Code"; Rec."Global Dimension 3 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.';
                }
                field("Global Dimension 4 Code"; Rec."Global Dimension 4 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 4 Code field.';
                }
                field("Global Dimension 5 Code"; Rec."Global Dimension 5 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Global Dimension 5 Code field.';
                }
            }
            group(Research)
            {
                Caption = 'Research Project';
                Visible = isVisibleResearch;
                field("Project Location"; Rec."Project Location")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Project Location field.';
                }
                
                field("Type of Study"; Rec."Type of Study")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type of Study field.';
                }
                field("Main Achievement"; Rec."Main Achievement")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Main Achievement field.';
                }
                field("Challenges and Constraints Q1"; Rec."Challenges and Constraints Q1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Challenges and Constraints Q1 field.';
                }
                field("Challenges and Constraints Q2"; Rec."Challenges and Constraints Q2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Challenges and Constraints Q2 field.';
                }
                field("Challenges and Constraints Q3"; Rec."Challenges and Constraints Q3")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Challenges and Constraints Q3 field.';
                }
                field("Challenges and Constraints Q4"; Rec."Challenges and Constraints Q4")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Challenges and Constraints Q4 field.';
                }

            }
            group(Development)
            {
                Caption = 'Development Project';
                Visible = isVisibleDevelopment;
                field("Project Location(GPS)"; Rec."Project Location")
                {
                    ApplicationArea = basic;
                    caption = 'Project Location(GPS Coordinates)';
                    ToolTip = 'Specifies the value of the Project Location(GPS Coordinates) field.';
                }
            }
        }
    }


    actions
    {
        addbefore("Copy Job Tasks &from...")
        {
            action("Create Project")
            {
                Caption = 'Create Project as Dimension';
                ApplicationArea = basic;
                Image = Dimensions;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Create Project as Dimension action.';
                trigger OnAction()
                var
                    Dimensions: record "Dimension Value";
                begin
                    //if project is not a dimension crea
                    Dimensions.reset;
                    Dimensions.SetRange("Dimension Code", 'PROJECT');
                    Dimensions.SetRange(Code, Rec."Workplan Activity Code");
                    if not Rec.find('-') then begin
                        Dimensions.init;
                        Dimensions."Dimension Code" := 'PROJECT';
                        Dimensions.Code := Rec."Workplan Activity Code";
                        Dimensions.Name := Rec.Description;
                        Dimensions.insert(true);
                        Rec."Global Dimension 4 Code" := Rec."Workplan Activity Code";
                        message('Project Successfully Created as a dimension');
                    end else
                        error('Project alrady exists with Code ' + Rec."Workplan Activity Code");
                end;
            }
            action("Milestones")
            {
                Caption = 'Project Milestones';
                ApplicationArea = basic;
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "Project Milestones";
                RunPageLink = "Project Code" = field("No.");
                ToolTip = 'Executes the Project Milestones action.';

            }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                ApplicationArea = basic;
                Promoted = true;
                ToolTip = 'Executes the Send Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    varVar: Variant;
                begin

                    varVar := rec;

                    ApprovalMgt.OnSendDocForApproval(varVar);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    VaraVar: Variant;
                begin
                    VaraVar := rec;
                    ApprovalMgt.OnCancelDocApprovalRequest(VaraVar);
                end;
            }

        }
    }

    var
        isVisibleResearch: Boolean;
        isVisibleDevelopment: Boolean;

    trigger OnOpenPage()
    begin
        isVisibleResearch := false;
        isVisibleDevelopment := false;
    end;
}