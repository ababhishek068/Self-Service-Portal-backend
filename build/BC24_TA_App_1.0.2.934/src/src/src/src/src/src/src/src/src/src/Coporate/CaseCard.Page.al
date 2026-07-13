page 50507 "Case Card"
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
                    caption = 'Date Reported';
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Date Reported field.';

                }
                field("Type of Offence"; Rec."Type of Offence")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Type of Offence field.';

                }
                field("Case Nature"; Rec."Case Nature")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Case Nature field.';
                }
                field("Case Description"; Rec."Case Description")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Case Description field.';

                }

                field("Offense Date"; Rec."Offense Date")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Offense Date field.';

                }
                field("Offense Time"; Rec."Offense Time")
                {
                    ApplicationArea = All;
                    NotBlank = true;
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
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Priority field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Sacco No"; Rec."Sacco No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sacco No field.';
                }
                field("Sacco Name"; Rec."Sacco Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sacco Name field.';
                }
                field("Handed Over On"; Rec."Handed Over On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handed Over On field.';
                }
                field("Handed Over By"; Rec."Handed Over By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Handed Over By field.';
                }
                field("Taken Over By"; Rec."Taken Over By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Taken Over By field.';
                }
                field("Taken Over On"; Rec."Taken Over On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Taken Over On field.';
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
            group(Functions)
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


            }
            group("Case Actions")
            {
                action("Submit to Investigation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Submit to Investigation action.';
                    trigger OnAction()
                    var
                        SMTPMail: Codeunit "Email Message";
                        Investigators: record "Case Officers";
                        Emp: record "HR-Employee";
                    begin
                        if Confirm('Do you really want to submit to Investigation?') then begin
                            Rec.CalcFields("Investigators Count");
                            if Rec."Investigators Count" = 0 then error('Select the case investigators');

                            Investigators.reset;
                            Investigators.setrange("Case No", Rec."Case No");
                            if Investigators.find('-') then begin
                                repeat
                                    if Emp.get(Investigators."Employee No") then begin
                                        if Emp."Company E-Mail" <> '' then begin
                                            SMTPMail.Create(emp."Company E-Mail", 'Case Allocation', 'Please note that you have been allocated Case No. :' + Rec."Case No" + 'Description: ' + Rec."Case Description");
                                        end;
                                    end;
                                until Investigators.next = 0;
                            end;
                            Rec.Status := Rec.Status::Investigation;
                            Rec.modify;
                        end;
                    end;
                }
            }
            group("Approval Request")
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin
                        // TestField(Status, Status::" ");


                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin

                        VarVariant := Rec; //Added
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

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
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }

            }

        }


    }
}