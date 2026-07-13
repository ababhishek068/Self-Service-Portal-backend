page 50342 "Vendor User Buffer List"
{
    CardPageID = "Vendor User Buffer Card";
    PageType = List;
    SourceTable = "Vendor User Buffer";
    Caption = 'Pre-qualified Suppliers';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID; Rec.UserID)
                {
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("Company Registration No"; Rec."Company Registration No")
                {
                    ToolTip = 'Specifies the value of the Company Registration No field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Telephone No"; Rec."Telephone No")
                {
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Kra Pin"; Rec."Kra Pin")
                {
                    ToolTip = 'Specifies the value of the Kra Pin field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                begin
                    SuppCu.SubmitRegistration(Rec."Company Registration No", Rec.UserID);
                end;
            }
            action("Convert to Vendor")
            {
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Convert to Vendor action.';

                trigger OnAction()
                begin
                    IF Rec.Status <> Rec.Status::Approved THEN ERROR('Vendor Status must be equal to approved to proceed');
                    vendor.RESET;
                    vendor.SETRANGE("TIN No.", Rec."Kra Pin");
                    IF vendor.FIND('-') THEN ERROR('Vendor Already Exists with Vendor No.' + vendor."No.");
                    vendor.INIT;
                    ProcSetup.Get();
                    NextNo := NoSeriesMgt.GetNextNo(ProcSetup."Vendor Nos.", 0D, TRUE);
                    vendor."No." := NextNo;
                    vendor.Name := Rec."Company Name";
                    vendor.Address := Rec."Postal Code";
                    vendor."Address 2" := Rec."Street Address/Building No";
                    vendor."Phone No." := Rec."Telephone No";
                    vendor."E-Mail" := Rec.Email;
                    vendor."Search Name" := UPPERCASE(Rec."Company Name");
                    vendor.City := Rec.City;
                    vendor."Vendor Posting Group" := 'TRADE';
                    vendor."Application Method" := vendor."Application Method"::Manual;
                    vendor."VAT Registration No." := Rec."Kra Pin";
                    vendor."Gen. Bus. Posting Group" := 'LOCAL';
                    vendor."TIN No." := Rec."Kra Pin";
                    vendor."Vendor Category" := Rec."Vendor Category";
                    vendor.Image := Rec.Logo;
                    vendor.INSERT;

                    Rec."Vendor No" := NextNo;
                    Rec.MODIFY;
                    MESSAGE('Vendor Created Successfully');
                end;
            }
        }
    }

    var
        SuppCu: Codeunit "Suppliers Portal";
        vendor: Record Vendor;
        NoSeriesMgt: Codeunit "No. Series";
        NextNo: Code[20];
        ProcSetup: Record "Purchases & Payables Setup";
}

