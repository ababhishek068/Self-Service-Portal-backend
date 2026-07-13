page 51354 "FLT Fuel Requestion"
{
    caption = 'Fuel Requisition Card';
    PageType = Card;
    SourceTable = "FLT-Fuel & Maintenance Req.";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No field.';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Vehicle Reg No"; Rec."Vehicle Reg No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vehicle Reg No field.';
                }
                field("Vendor(Dealer)"; Rec."Vendor(Dealer)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor(Dealer) field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field("Date Taken for Fueling"; Rec."Date Taken for Fueling")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Taken for Fueling field.';
                }
                field("Type of Fuel"; Rec."Type of Fuel")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Fuel field.';
                }
                field("Quantity of Fuel(Litres)"; Rec."Quantity of Fuel(Litres)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity of Fuel(Litres) field.';
                }
                field("Price/Litre"; Rec."Price/Litre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Price/Litre field.';
                }
                field("Total Price of Fuel"; Rec."Total Price of Fuel")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Price of Fuel field.';
                }
                field("Oil Type"; Rec."Oil Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Oil Type field.';
                }
                field("Oil Litres"; Rec."Oil Litres")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Oil Litres field.';
                }
                field(Oil; Rec.Oil)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Oil field.';
                }
                field(Coolant; Rec.Coolant)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Coolant field.';
                }
                field("Car Wash"; Rec."Car Wash")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Car Wash field.';
                }
                field("Battery Water"; Rec."Battery Water")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Battery Water field.';
                }
                field("Wheel Alignment"; Rec."Wheel Alignment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Wheel Alignment field.';
                }
                field("Wheel Balancing"; Rec."Wheel Balancing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Wheel Balancing field.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field("Odometer Reading"; Rec."Odometer Reading")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Odometer Reading field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed By field.';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Closed field.';
                }
                field("Vendor Invoice No"; Rec."Vendor Invoice No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Invoice No field.';
                }
                field("Posted Invoice No"; Rec."Posted Invoice No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted Invoice No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Station';
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field("Driver Name"; Rec."Driver Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driver Name field.';
                }
                field("Fuel Card No"; Rec."Fuel Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fuel Card No field.';
                }
                field("Max. Amount Allocated"; Rec."Max. Amount Allocated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max. Amount Allocated field.';
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fixed Asset No field.';
                }
                field("Quote No"; Rec."Quote No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quote No field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
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
                    // TESTFIELD( Commencement);
                    // TESTFIELD(Destination );
                    // TESTFIELD("Date of Trip");
                    // TESTFIELD("Purpose of Trip");

                    //"Date Requisition Received":=TODAY;
                    //"Time Requisition Received":=TIME;

                    //MODIFY;
                    Variant := rec;

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
                    DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                    Variant: Variant;
                begin
                    DocType := DocType::Fuel;
                    Variant := Rec;
                    ApprovalMgt.OnCancelDocApprovalRequest(Variant);
                end;
            }
            separator(Separator21) { }
            action("Print Preview")
            {
                Image = Print;
                ToolTip = 'Executes the Print Preview action.';
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    FuelReq.Reset;
                    FuelReq.SetFilter(FuelReq."Requisition No", Rec."Requisition No");
                    if FuelReq.Find('-') then
                        REPORT.Run(70134948, true, true, FuelReq);
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
            FltMgtSetup.TestField(FltMgtSetup."Fuel Register");
            Rec."Requisition No":=NoSeriesMgt.GetNextNo(FltMgtSetup."Fuel Register", 0D, true);
        end;
        Rec.Type := Rec.type::Fuel;
        Rec.Status := Rec.Status::Open;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::TransportRequest;
    end;

    var
        FuelReq: Record "FLT-Fuel & Maintenance Req.";
}

