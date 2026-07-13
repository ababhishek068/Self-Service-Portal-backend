
page 51449 "Payment Requisition Card"
{
    ApplicationArea = All;
    Caption = 'Payment Requisition Card';
    PageType = Card;

    SourceTable = "payment memo";



    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Requisition No"; Rec."Requisition No")
                {
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field("Requesting User"; Rec."Requesting User")
                {
                    ToolTip = 'Specifies the value of the Requesting User field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field("Requisition Time"; Rec."Requisition Time")
                {
                    ToolTip = 'Specifies the value of the Requisition Time field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ToolTip = 'Specifies the value of the Supplier  field.';
                }
                field("Supplier Invoice Number"; Rec."Supplier Invoice Number")
                {
                    ToolTip = 'Specifies the value of the Supplier Invoice Number field.';
                    // TODO: Check open Invoices only
                }
                
                field("Supplier Delivery Note No"; Rec."Supplier Delivery Note No")
                {
                    ToolTip = 'Specifies the value of the Supplier Delivery Note No field.';
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ToolTip = 'Specifies the value of the Supplier Name field.';
                }
                field("Due Amount"; Rec."Due Amount")
                {
                    ToolTip = 'Specifies the value of the Due Amount field.';
                }
                field("Amount to Pay";Rec."Amount to Pay"){}
                field("Partial Payment";Rec."Partial Payment"){}
                field(Reason;Rec.Reason){}

                field("Invoice Due Date"; Rec."Invoice Due Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Due Date field.';
                }
                field("Payment Remarks"; Rec."Payment Remarks")

                {
                    ToolTip = 'Specifies the value of the Payment Remarks field.';
                    MultiLine = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Project.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Donor.';
                }
                field("View Document"; Rec."View Document")
                {
                    ToolTip = 'Specifies the value of the View Supplier Invoice field.';
                }
                field("Order No";Rec."Order No"){
                    Caption='PO Number';
                    Editable=false;
                }
                field(GRN;Rec.GRN){}
                field("PV Number"; Rec."PV Number")
                {
                    ToolTip = 'Specifies the value of the PV Number field.';
                }

            }
        }
        area(FactBoxes)
        {
            
        
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Payment Memo"),
                              "No." = FIELD("Requisition No");
            }
           
        
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = all;
                Caption = 'Generate Payment';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Generate Payment action.';

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    if confirm('Convert to PV') = true then
                        Rec.ConvertToPaymentVoucher();
                end;
            }
            group(ApprovalsRequests)
            {
                Caption = 'Send Approvals';
                Image = ApprovalSetup;

                action(SendsApproval)
                {
                    ApplicationArea = All;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction()
                    begin
                        Rec.TestField("Supplier Invoice Number");
                        Rec.TestField(Status, Rec.Status::Open);
                        VarVariant := Rec;
                        if CustomApprovalCodeunit.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovalCodeunit.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(cancelsApproval)
                {
                    ApplicationArea = all;
                    Caption = 'Cancel Approval Request';
                    image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        VarVariant := Rec;
                        CustomApprovalCodeunit.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = all;
                    Caption = 'Approvals';
                    image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        AppEntry: Record "Approval Entry";
                        AppEntryPage: page "Approval Entries2";

                    begin
                        AppEntry.reset;
                        AppEntry.setrange("Document No.", Rec."Requisition No");
                        if AppEntry.find('-') then begin
                            AppEntryPage.SetTableView(AppEntry);
                            AppEntryPage.Run();
                        end;
                    end;

                }
            }
        }
    }
    var
        VarVariant: Variant;
        CustomApprovalCodeunit: Codeunit "Custom Approvals Codeunit";
}

