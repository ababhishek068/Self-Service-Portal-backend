Page 50718 "Restricted Tendering List"
{
    CardPageID = "Restricted Tendering";
    PageType = List;
    SourceTable = "Purchase Quote Header";
    SourceTableView = where("Document Type" = const("Restricted Tender"),
                            Status = filter(<> Released));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(YourReference; Rec."Your Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Your Reference field.';
                }
                field(ExpectedOpeningDate; Rec."Expected Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Opening Date field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(ExpectedClosingDate; Rec."Expected Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Closing Date field.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Discount % field.';
                }
                field(PmtDiscountDate; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pmt. Discount Date field.';
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shipment Method Code field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(VendorPostingGroup; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Posting Group field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(PricesIncludingVAT; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prices Including VAT field.';
                }
                field(InvoiceDiscCode; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Disc. Code field.';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Language Code field.';
                }
                field(PurchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purchaser Code field.';
                }
                field(OrderClass; Rec."Order Class")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Order Class field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PaytoICPartnerCode; Rec."Pay-to IC Partner Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay-to IC Partner Code field.';
                }
                field(ICDirection; Rec."IC Direction")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the IC Direction field.';
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quote No. field.';
                }
                field(NoofArchivedVersions; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. of Archived Versions field.';
                }
                field(DocNoOccurrence; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc. No. Occurrence field.';
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                }
                field(Copied; Rec.Copied)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Copied field.';
                }
                field(DebitNote; Rec."Debit Note")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Debit Note field.';
                }
                field(PRFNo; Rec."PRF No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PRF No field.';
                }
                field(ReleasedBy; Rec."Released By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Released By field.';
                }
                field(ReleaseDate; Rec."Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Release Date field.';
                }
            }
        }
    }

    actions { }
}

