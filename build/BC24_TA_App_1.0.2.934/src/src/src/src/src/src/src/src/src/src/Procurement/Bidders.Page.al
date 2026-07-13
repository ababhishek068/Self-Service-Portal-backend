#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51501 Bidders1
{
    SourceTable = Bidders1;

    layout
    {
        area(content)
        {
            repeater(Control16)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Tender Amount";"Tender Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Bid Security Amount";"Bid Security Amount")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Copies Submitted";"No. of Copies Submitted")
                {
                    ApplicationArea = Basic;
                }
                field("Physical Address";"Physical Address")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("E-mail";"E-mail")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No";"Telephone No")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile No";"Mobile No")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Person";"Contact Person")
                {
                    ApplicationArea = Basic;
                }
                field("Pre Qualified";"Pre Qualified")
                {
                    ApplicationArea = Basic;
                }
                field(Successful;Successful)
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Asset No";"Fixed Asset No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No";"Cheque No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Bidders)
            {
                Caption = 'Bidders';
                action("Mandatory Requirements -Compliance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mandatory Requirements -Compliance';
                    Image = ReminderTerms;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Bidder Mandatory Requirements";
                    RunPageLink = "Tender No"=field("Ref No."),
                                  "Company Name"=field(Name);

                    trigger OnAction()
                    begin
                        MandatoryReq.Reset;
                        MandatoryReq.SetRange(MandatoryReq."Tender No","Ref No.");
                        if MandatoryReq.Find('-') then
                        repeat
                          BidderMandatory."Tender No":="Ref No.";
                          BidderMandatory."Company Name":=Name;
                          BidderMandatory."Mandatory Requirement":=MandatoryReq.code;
                          if not BidderMandatory.Get(BidderMandatory."Tender No",BidderMandatory."Company Name",BidderMandatory."Mandatory Requirement")
                          then
                          BidderMandatory.Insert;

                        until MandatoryReq.Next=0;
                    end;
                }
            }
        }
    }

    var
        MandatoryReq: Record "Tender Required Documents";
        BidderMandatory: Record "Bidder Mandatory Requirements";
}

