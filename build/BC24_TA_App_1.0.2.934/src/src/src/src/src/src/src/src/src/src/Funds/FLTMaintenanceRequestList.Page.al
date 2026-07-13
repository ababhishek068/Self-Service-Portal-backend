Page 50633 "FLT Maintenance Request List"
{
    CardPageID = "FLT Maintenance Request";
    PageType = List;
    SourceTable = "FLT-Fuel & Maintenance Req.";
    SourceTableView = where(Status = const(Open),
                          "Maintenance Type" = filter(Other),
                            Type = filter(Maintenance));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(RequisitionNo; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field(VehicleRegNo; Rec."Vehicle Reg No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field(VendorDealer; Rec."Vendor(Dealer)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor(Dealer) field.';
                }
                field(QuantityofFuelLitres; Rec."Quantity of Fuel(Litres)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity of Fuel(Litres) field.';
                }
                field(TotalPriceofFuel; Rec."Total Price of Fuel")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Price of Fuel field.';
                }
                field(OdometerReading; Rec."Odometer Reading")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Odometer Reading field.';
                }
                field(RequestDate; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field(DateTakenforFueling; Rec."Date Taken for Fueling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Taken for Fueling field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PreparedBy; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(ClosedBy; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field(DateClosed; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field(VendorInvoiceNo; Rec."Vendor Invoice No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Invoice No field.';
                }
                field(PostedInvoiceNo; Rec."Posted Invoice No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted Invoice No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(VendorName; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(DateTakenforMaintenance; Rec."Date Taken for Maintenance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Taken for Maintenance field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(TypeofMaintenance; Rec."Type of Maintenance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Maintenance field.';
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field(DriverName; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field(FixedAssetNo; Rec."Fixed Asset No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fixed Asset No field.';
                }
                field(Oil; Rec.Oil)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Oil field.';
                }
                field(QuoteNo; Rec."Quote No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quote No field.';
                }
                field(PriceLitre; Rec."Price/Litre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Price/Litre field.';
                }
                field(TypeofFuel; Rec."Type of Fuel")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Fuel field.';
                }
                field(Coolant; Rec.Coolant)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Coolant field.';
                }
                field(BatteryWater; Rec."Battery Water")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Battery Water field.';
                }
                field(WheelAlignment; Rec."Wheel Alignment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Wheel Alignment field.';
                }
                field(WheelBalancing; Rec."Wheel Balancing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Wheel Balancing field.';
                }
                field(CarWash; Rec."Car Wash")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Car Wash field.';
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
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin
                    DocumentType := Documenttype::TR;
                    ApprovalEntries.SetRecordFilters(Database::"FLT-Fuel & Maintenance Req.", DocumentType, Rec."Requisition No");
                    ApprovalEntries.Run;
                end;
            }
            action(sendApproval)
            {
                ApplicationArea = Basic;
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
                ApplicationArea = Basic;
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

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
}

