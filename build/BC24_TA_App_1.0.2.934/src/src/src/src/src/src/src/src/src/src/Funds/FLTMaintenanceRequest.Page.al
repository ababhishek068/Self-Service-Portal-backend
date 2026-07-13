page 50632 "FLT Maintenance Request"
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
            group(General)//
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field("Vendor(Dealer)"; Rec."Vendor(Dealer)")
                {
                    ToolTip = 'Specifies the value of the Vendor(Dealer) field.';
                }


                field("Odometer Reading"; Rec."Odometer Reading")
                {
                    ToolTip = 'Specifies the value of the Odometer Reading field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the value of the Request Date field.';
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
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                /* field("Date Taken for Maintenance"; "Date Taken for Maintenance")
                {
                } */
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Type of Maintenance"; Rec."Type of Maintenance")
                {
                    ToolTip = 'Specifies the value of the Type of Maintenance field.';
                }
                field("Maintenance Description"; Rec."Maintenance Description")
                {
                    ToolTip = 'Specifies the value of the Maintenance Description field.';
                }
                field("Last Service Date"; Rec."Last Service Date")
                {
                    ToolTip = 'Specifies the value of the Last Service Date field.';

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
                field(Oil; Rec.Oil)
                {
                    ToolTip = 'Specifies the value of the Oil field.';
                }
                field("Quote No"; Rec."Quote No")
                {
                    ToolTip = 'Specifies the value of the Quote No field.';
                }
                field("Price/Litre"; Rec."Price/Litre")
                {
                    ToolTip = 'Specifies the value of the Price/Litre field.';
                }
                field("Type of Fuel"; Rec."Type of Fuel")
                {
                    ToolTip = 'Specifies the value of the Type of Fuel field.';
                }
                field(Coolant; Rec.Coolant)
                {
                    ToolTip = 'Specifies the value of the Coolant field.';
                }
                field("Battery Water"; Rec."Battery Water")
                {
                    ToolTip = 'Specifies the value of the Battery Water field.';
                }
                field("Wheel Alignment"; Rec."Wheel Alignment")
                {
                    ToolTip = 'Specifies the value of the Wheel Alignment field.';
                }
                field("Wheel Balancing"; Rec."Wheel Balancing")
                {
                    ToolTip = 'Specifies the value of the Wheel Balancing field.';
                }
                field("Car Wash"; Rec."Car Wash")
                {
                    ToolTip = 'Specifies the value of the Car Wash field.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ToolTip = 'Specifies the value of the Total Cost field.';

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
    var
        FltMgtSetup: Record "FLT-Fleet Mgt Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec."Requisition No" = '' then begin
            FltMgtSetup.Get;
            FltMgtSetup.TestField(FltMgtSetup."Maintenance Request");
            Rec."Requisition No":=NoSeriesMgt.GetNextNo(FltMgtSetup."Maintenance Request", 0D, true);
        end;
        Rec.Type := Rec.type::Maintenance;
        Rec.Status := Rec.Status::Open;
    end;


}

