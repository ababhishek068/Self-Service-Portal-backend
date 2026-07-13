page 50513 "Case Investigation Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = cases;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Case No"; Rec."Case No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case No field.';

                }
                field("Date Reported"; Rec."Case Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case Date field.';

                }

                field("Case Description"; Rec."Case Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case Description field.';
                }
                field("Type of Offence"; Rec."Type of Offence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Offence field.';

                }
                field("Offense Date"; Rec."Offense Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offense Date field.';

                }
                field("Offense Time"; Rec."Offense Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offense Time field.';

                }
                field("Offense Place"; Rec."Offense Place")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Offense Place field.';
                }
                field("Amount Involved"; Rec."Amount Involved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Involved field.';

                }
                field("Amount Recovered"; Rec."Amount Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Recovered field.';

                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';

                }
                field("Plea Date"; Rec."Plea Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Plea Date field.';

                }
                field("Verdict"; Rec."Verdict Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verdict Status field.';
                }
                field("Mention Date"; Rec."Mention Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mention Date field.';

                }
                field("Hearing Date"; Rec."Hearing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Hearing Date field.';

                }
                field("Date of submission to ODPP"; Rec."Date of submission to ODPP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of submission to ODPP field.';
                }

                field(Reference; Rec.Reference)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference field.';
                }


                field("Trial Status"; Rec."Trial Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trial Status field.';
                }
                field(Sentence; Rec.Sentence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sentence field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Court File No."; Rec."Court File No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Court File No. field.';
                }
                field("Court Name"; Rec."Court Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Court Name field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Submission Date field.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50900),
                              "No." = FIELD("Case No");
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }


    actions
    {
        area(Processing)
        {

            action("Investigating Officers")
            {
                ApplicationArea = All;
                RunObject = page "Case Officers";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the Investigating Officers action.';
            }
            action("Complainant")
            {
                ApplicationArea = All;
                RunObject = page "Case Complainant";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the Complainant action.';
            }

            action("Suspects")
            {
                ApplicationArea = All;
                RunObject = page "Case Suspects";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the Suspects action.';
            }
            action("Withness")
            {
                ApplicationArea = All;
                RunObject = page "Case Withness";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the Withness action.';
            }
            action("HearingDates")
            {
                ApplicationArea = All;
                RunObject = page "Case Hearing Dates";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the HearingDates action.';
            }
            action("MentionDates")
            {
                ApplicationArea = All;
                RunObject = page "Case Mention Dates";
                RunPageLink = "Case No" = field("Case No");
                ToolTip = 'Executes the MentionDates action.';
            }
            group("Case Actions")
            {
                action("Submit to ODPP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Submit to ODPP action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to submit to ODPP?') then begin
                            Rec.CalcFields("Investigators Count");
                            if Rec."Investigators Count" = 0 then error('Please select the Investigators');
                            Rec.Status := Rec.Status::ODPP;
                            Rec."Submission Date" := today;
                            Rec.modify;
                        end;
                    end;
                }
                action("No Further Police Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the No Further Police Action action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark as No further police action?') then begin
                            Rec.Status := Rec.Status::"No Further Police Action";
                            Rec.modify;
                        end;
                    end;
                }
                action("Withdrawn")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Withdrawn action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark as Withdrawn?') then begin
                            Rec.Status := Rec.Status::Withdrawn;
                            Rec.modify;
                        end;
                    end;
                }
                action("Mark As Pending Arrest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Mark As Pending Arrest action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark as Pending Arrest?') then begin
                            Rec.Status := Rec.Status::"Pending Arrest";
                            Rec.modify;
                        end;
                    end;
                }
                action("Submit to Court")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Submit to Court action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark as Pending before Court?') then begin
                            Rec.Status := Rec.Status::"Pending Before Court";
                        end;
                    end;
                }
                action("Mark As Convicted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Mark As Convicted action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark as Convicted?') then begin
                            Rec.Status := Rec.Status::Convicted;
                        end;
                    end;
                }

            }
            group(Approval)
            {
                action(sendApproval)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;

                    PromotedIsBig = true;
                    ApplicationArea = basic;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                        CustomApprovals: Codeunit "Custom Approvals Codeunit";
                    begin


                        //Release the PV for Approval
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(cancellsApproval)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    ApplicationArea = basic;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                        CustomApprovals: Codeunit "Custom Approvals Codeunit";
                    begin

                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

            }
        }
    }
}