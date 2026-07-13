page 50578 "Other Maintenance Request Card"
{
    PageType = Card;
    SourceTable = "FLT-Fuel & Maintenance Req.";
    SourceTableView = WHERE(Status = CONST(Open),
                            Type = FILTER(Maintenance));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field("Quantity of Fuel(Litres)"; Rec."Quantity of Fuel(Litres)")
                {
                    ToolTip = 'Specifies the value of the Quantity of Fuel(Litres) field.';
                }
                field("Total Price of Fuel"; Rec."Total Price of Fuel")
                {
                    ToolTip = 'Specifies the value of the Total Price of Fuel field.';
                }
                field("Odometer Reading"; Rec."Odometer Reading")
                {
                    ToolTip = 'Specifies the value of the Odometer Reading field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field("Date Taken for Fueling"; Rec."Date Taken for Fueling")
                {
                    ToolTip = 'Specifies the value of the Date Taken for Fueling field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field("Vendor Invoice No"; Rec."Vendor Invoice No")
                {
                    ToolTip = 'Specifies the value of the Vendor Invoice No field.';
                }
                field("Posted Invoice No"; Rec."Posted Invoice No")
                {
                    ToolTip = 'Specifies the value of the Posted Invoice No field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Date Taken for Maintenance"; Rec."Date Taken for Maintenance")
                {
                    ToolTip = 'Specifies the value of the Date Taken for Maintenance field.';
                }
                field("Type of Maintenance"; Rec."Type of Maintenance")
                {
                    ToolTip = 'Specifies the value of the Type of Maintenance field.';
                }
                field("Maintenance Description"; Rec."Maintenance Description")
                {
                    ToolTip = 'Specifies the value of the Maintenance Description field.';
                }
                field(Driver; Rec.Driver)
                {
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                    ToolTip = 'Specifies the value of the Fixed Asset No field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin
                    /*
                    DocumentType:=DocumentType::TR;
                    ApprovalEntries.SetRecordFilters(DATABASE::"FLT-Fuel & Maintenance Req.",DocumentType,"Requisition No");
                    ApprovalEntries.RUN;
                     */

                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    Variant: Variant;
                begin
                    Rec.TestField(Status, Rec.Status::Open);

                    Variant := Rec;
                    ApprovalMgt.OnSendDocForApproval(Variant);
                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    Variant: Variant;
                begin
                    Rec.TestField(Status, Rec.Status::Open);

                    Variant := Rec;
                    ApprovalMgt.OnCancelDocApprovalRequest(Variant);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.type::Maintenance;
        Rec.Status := Rec.Status::Open;
    end;
}

