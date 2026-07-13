page 50271 "Service Transfer Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Service Transfer Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'Current Station';
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Type of Transfer"; Rec."Type of Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Transfer field.';

                }
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Service Unit field.';
                }
                field("Commanding Officer"; Rec."Service Commander")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Commander field.';

                }
                // field("Service Duty"; "Service Duty")
                // {
                //     ApplicationArea = All;

                // }
                // field("Service Sub Duty"; "Service Sub Duty")
                // {
                //     ApplicationArea = All;

                // }
                field("Transfer Reason"; Rec."Transfer Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Reason field.';
                }
                field("Expected Release Date"; Rec."Expected Release Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Release Date field.';
                }
            }
            group(New)
            {
                caption = 'New Station';
                field("New Service Region"; Rec."New Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Region field.';

                }
                field("New Service Unit"; Rec."New Service Unit")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the New Service Unit field.';
                }
                field("New Service Commander"; Rec."New Service Commander")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Service Commander field.';
                }
                field("New Service Duty"; Rec."New Service Duty")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the New Service Duty field.';
                }
                field("New Service Sub Duty"; Rec."New Service Sub Duty")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the New Service Sub Duty field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field("Expected Arrival Date"; Rec."Expected Arrival Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Arrival Date field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';

                }

            }
            part(AllocationLines; "Service Transfer Line")
            {
                ApplicationArea = basic;
                Caption = 'Transfer Lines';
                SubPageLink = "Service Unit" = field("Service Unit"), "Allocation No" = field(No), "Main Duty" = field("New Service Duty"), "Sub Duty" = field("New Service Sub Duty");
            }
        }
        area(Factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135563),
                              "No." = FIELD(No);
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
                        Rec.TestField(Status, Rec.Status::New);


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


            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Post Transfer';
                Image = PostedPutAway;
                Promoted = true;
                ToolTip = 'Executes the Post Transfer action.';
                trigger OnAction();
                var
                    RegForm: Record "Registration Form";
                    DutiesAll: record "Service Transfer Line";
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("New Service Unit");
                    Rec.TestField("New Service Duty");

                    if Confirm('Do you really want to post the allocation', false) then begin

                        DutiesAll.reset;
                        DutiesAll.setrange("Allocation No", Rec.No);
                        if DutiesAll.find('-') then begin
                            repeat
                                if RegForm.get(DutiesAll."Serial No") then begin
                                    RegForm."Current Station" := Rec."New Service Unit";
                                    RegForm."Current Sub Duty" := '';
                                    RegForm."Current Main Duty" := '';
                                    RegForm.modify;
                                end;
                            until DutiesAll.next = 0;
                        end;

                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.modify;
                    end;
                end;
            }
        }
    }
}