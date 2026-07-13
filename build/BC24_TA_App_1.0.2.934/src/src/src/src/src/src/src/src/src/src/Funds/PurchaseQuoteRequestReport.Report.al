Report 50193 "Purchase Quote Request Report"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    // RDLCLayout = './Layouts/PurchaseQuoteRequestReport.rdlc';

    dataset
    {
        dataitem("Purchase Quote Header"; "Purchase Quote Header")
        {
            column(ReportForNavId_9738; 9738) { }
            column(Purchase_Quote_Header_Document_Type; "Document Type") { }
            column(Purchase_Quote_Header_No_; "No.") { }
            dataitem("Quotation Request Vendors"; "Quotation Request Vendors")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Requisition Document No." = field("No.");
                column(ReportForNavId_2583; 2583) { }
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No__; "Quotation Request Vendors"."Requisition Document No.") { }
                column(Today; Today) { }
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Vendor_Name_; "Quotation Request Vendors"."Vendor Name") { }
                column(companyinfo_Picture; companyinfo.Picture) { }
                column(vendAddress; vendAddress) { }
                column(Purchase_Quote_Header___Expected_Closing_Date_; "Purchase Quote Header"."Expected Closing Date") { }
                column(Purchase_Quote_Header___Expected_Closing_Date__Control1102755076; "Purchase Quote Header"."Expected Closing Date") { }
                column(Quotation_Request_Vendors__Quotation_Request_Vendors___Document_No___Control1000000001; "Quotation Request Vendors"."Requisition Document No.") { }
                column(Purchase_Quote_Header___Posting_Description_; "Purchase Quote Header"."Posting Description") { }
                column(P_o_Box_30746__Tel__254_020_247277__Fax__254020_310223Caption; P_o_Box_30746__Tel__254_020_247277__Fax__254020_310223CaptionLbl) { }
                column(THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaption; THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaptionLbl) { }
                column(for_supply_of___________________________________Caption; for_supply_of___________________________________CaptionLbl) { }
                column(ORIGINALCaption; ORIGINALCaptionLbl) { }
                column(DataItem1102755005; 'and_be_addressed_to_reach_the_buyer_on_or_before___________________________________________________________or_be_placed_in_thLbl') { }
                column(DataItem1102755007; 'c__Your_Quotation_should_indicate_final_unit_price_which_includes_all_costs_for_Delivery__discounts_duty_and_V_A_T_CaptionLbl') { }
                column(REQUEST_FOR_QUOTATIONCaption; REQUEST_FOR_QUOTATIONCaptionLbl) { }
                column(Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_Caption; Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_CaptionLbl) { }
                column(Days_to_DeliverCaption; Days_to_DeliverCaptionLbl) { }
                column(RemarksCaption; RemarksCaptionLbl) { }
                column(Country_of_OriginCaption; Country_of_OriginCaptionLbl) { }
                column(BrandCaption; BrandCaptionLbl) { }
                column(Quotation_No_____________________________________________________Caption; Quotation_No_____________________________________________________CaptionLbl) { }
                column(Unit_PriceCaption; Unit_PriceCaptionLbl) { }
                column(a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_Caption; a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_CaptionLbl) { }
                column(Quantity_RequiredCaption; Quantity_RequiredCaptionLbl) { }
                column(b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaption; b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaptionLbl) { }
                column(d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_Caption; d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_CaptionLbl) { }
                column(Quotation_No__Caption; Quotation_No__CaptionLbl) { }
                column(You_are_invited_to_submit_Quotation_on_materials_listed_below_Caption; You_are_invited_to_submit_Quotation_on_materials_listed_below_CaptionLbl) { }
                column(UnitCaption; UnitCaptionLbl) { }
                column(Date_Caption; Date_CaptionLbl) { }
                column(Item_DescriptionCaption; Item_DescriptionCaptionLbl) { }
                column(Seller_s_Name_and_Address_Caption; Seller_s_Name_and_Address_CaptionLbl) { }
                column(CodeCaption; CodeCaptionLbl) { }
                column(NOTE_Caption; NOTE_CaptionLbl) { }
                column(To_Caption; To_CaptionLbl) { }
                column(Quotation_Request_Vendors_Vendor_No_; "Vendor No.") { }
                column(Quotation_Request_Vendors_Document_Type; "Document Type") { }
                dataitem("Purchase Quote Line"; "Purchase Quote Line")
                {
                    DataItemLink = "Document No." = field("Requisition Document No.");
                    column(ReportForNavId_3368; 3368) { }
                    column(Purchase_Quote_Line__Unit_of_Measure_; "Unit of Measure") { }
                    column(Purchase_Quote_Line_Quantity; Quantity) { }
                    column(Purchase_Quote_Line_Description; Description) { }
                    column(Purchase_Quote_Line__Purchase_Quote_Line___No__; "Purchase Quote Line"."No.") { }
                    column(Purchase_Quote_Line__Extended_Order_Description_; "Extended Order Description") { }
                    column(Date_____________________________________________________________________________________________________________Caption; 'Date_____________________________________________________________________________________________________________CaptionLbl') { }
                    column(DataItem1102755059; 'V3_______________________________________Designation_____________________________________Signature___________________________Lbl') { }
                    column(DataItem1102755060; 'Date_________________________________________________________________________Time____________________________________________Lbl') { }
                    column(DataItem1102755061; 'V2_______________________________________Designation_____________________________________Signature___________________________Lbl') { }
                    column(Seller_s_Signature___________________________________________________________________________________________Caption; Seller_s_Signature___________________________________________________________________________________________CaptionLbl) { }
                    column(Opened_By_Caption; Opened_By_CaptionLbl) { }
                    column(DataItem1102755064; 'V1_______________________________________Designation_____________________________________Signature___________________________Lbl') { }
                    column(FOR_OFFICIAL_USE_ONLYCaption; FOR_OFFICIAL_USE_ONLYCaptionLbl) { }
                    column(Purchase_Quote_Line_Document_Type; "Document Type") { }
                    column(Purchase_Quote_Line_Document_No_; "Document No.") { }
                    column(Purchase_Quote_Line_Line_No_; "Line No.") { }
                }
                dataitem("Quotation Request Vendors2"; "Quotation Request Vendors")
                {
                    DataItemLink = "Vendor No." = field("Vendor No."), "Requisition Document No." = field("Requisition Document No.");
                    column(ReportForNavId_7905; 7905) { }
                    column(DataItem1102755019; 'V1_The_general_conditions_of_contract_with_the_Simlaw_Seed_Company_Ltd__apply_to_this_transaction__This_Form_properly_submittLbl') { }
                    column(V2_The_offer_shall_remain_firm_for_30_days_from_the_closing_date_unless_otherwise_stipulated_by_the_seller_Caption; 'V2_The_offer_shall_remain_firm_for_30_days_from_the_closing_date_unless_otherwise_stipulated_by_the_seller_CaptionLbl') { }
                    column(DataItem1102755066; 'V3_The_buyer_shall_not_be_bound_to_accept_the_lowest_or_any_other_offer__and_reserves_the_right_to_accept_any_offer_in_part_uLbl') { }
                    column(DataItem1102755067; 'V4_Samples_of_offers_when_required_will_be_provided_free__and_if_not_destroyed_during_tests_will__upon_request__be_returned_aLbl') { }
                    column(CONDITIONSCaption; CONDITIONSCaptionLbl) { }
                    column(INSTRUCTIONSCaption; INSTRUCTIONSCaptionLbl) { }
                    column(DataItem1102755070; 'V1_All_entries_must_be_typed_or_written_ink__Mistakes_must_not_be_erased_but_should_be_crossed_out_and_corrections_be_made_anLbl') { }
                    column(V2_Quote_on_each_item_separately__and_in_units_as_specified_Caption; V2_Quote_on_each_item_separately__and_in_units_as_specified_CaptionLbl) { }
                    column(V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_Caption; V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_CaptionLbl) { }
                    column(DataItem1102755073; 'V4_Each_quotation_should_be_separately_in_a_sealed_envelope_with_the_quotation_Number_endorsed_on_the_outside__Descriptive_liLbl') { }
                    column(DataItem1102755074; 'V5_If_you_do_not_wish_to_quote__please_endorse_the_reason_on_this_form_and_return_it__otherwise_your_name_may_be_deleted_fromLbl') { }
                    column(Quotation_Request_Vendors2_Document_No_; "Requisition Document No.") { }
                    column(Quotation_Request_Vendors2_Vendor_No_; "Vendor No.") { }
                }

                trigger OnAfterGetRecord()
                begin

                    vendor.Reset;
                    vendor.SetRange(vendor."No.", "Quotation Request Vendors"."Vendor No.");
                    if vendor.Find('-') then
                        vendAddress := vendor.Address;

                    Quote.Reset;
                    Quote.SetRange(Quote."No.", "Quotation Request Vendors"."Requisition Document No.");
                    Quote.SetRange(Quote."Document Type", Quote."document type"::"Quotation Request");
                    if Quote.Find('-') then
                        DocDesc := Quote."Posting Description";
                    //    DocDesc:=
                end;
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        companyinfo.Reset;
        companyinfo.Get;
        companyinfo.CalcFields(Picture);
    end;

    var
        DocDesc: Text[50];
        vendAddress: Text[50];
        Quote: Record "Purchase Quote Header";
        vendor: Record Vendor;
        companyinfo: Record "Company Information";
        P_o_Box_30746__Tel__254_020_247277__Fax__254020_310223CaptionLbl: label 'P.o Box 40042 00100 NAIROBI, Tel.+254-020-215066/7/83, Fax +254020-313361';
        THE_KENYATTA_INTERNATIONAL_CONFERENCE_CENTRECaptionLbl: label 'SIMLAW SEEDS COMPANY LIMITED';
        for_supply_of___________________________________CaptionLbl: label 'for supply of:..................................';
        ORIGINALCaptionLbl: label 'ORIGINAL';

        REQUEST_FOR_QUOTATIONCaptionLbl: label 'REQUEST FOR QUOTATION';
        Fill__Sign_And_Return_The_Original_To_Simlaw_Seed_Company_Limited__Even_If_You_Have_Not_Quoted_CaptionLbl: label '(Fill, Sign And Return The Original To Simlaw Seed Company Limited. Even If You Have Not Quoted)';
        Days_to_DeliverCaptionLbl: label 'Days to Deliver';
        RemarksCaptionLbl: label 'Remarks';
        Country_of_OriginCaptionLbl: label 'Country of Origin';
        BrandCaptionLbl: label 'Brand';
        Quotation_No_____________________________________________________CaptionLbl: label '"Quotation No...                                      ............';
        Unit_PriceCaptionLbl: label 'Unit Price';
        a__THIS_IS_NOT_AN_ORDER__Read_the_conditions_and_instructions_on_reverse_before_quoting_CaptionLbl: label '(a) THIS IS NOT AN ORDER. Read the conditions and instructions on reverse before quoting.';
        Quantity_RequiredCaptionLbl: label 'Quantity Required';
        b__This_Quotation_should_be_submitted_in_a_plain_wax_sealed_envelope_markedCaptionLbl: label '(b) This Quotation should be submitted in a plain wax sealed envelope marked';
        d___Return_the_Original_copy_and_retain_the_duplicate_for_your_records_CaptionLbl: label '(d)  Return the Original copy and retain the duplicate for your records.';
        Quotation_No__CaptionLbl: label 'Quotation No.:';
        You_are_invited_to_submit_Quotation_on_materials_listed_below_CaptionLbl: label 'You are invited to submit Quotation on materials listed below:';
        UnitCaptionLbl: label 'Unit';
        Date_CaptionLbl: label 'Date:';
        Item_DescriptionCaptionLbl: label 'Item Description';
        Seller_s_Name_and_Address_CaptionLbl: label 'Seller''s Name and Address:';
        CodeCaptionLbl: label 'Code';
        NOTE_CaptionLbl: label 'NOTE:';
        To_CaptionLbl: label 'To:';
        Seller_s_Signature___________________________________________________________________________________________CaptionLbl: label 'Seller''s Signature:..........................................................................................';
        Opened_By_CaptionLbl: label 'Opened By:';
        FOR_OFFICIAL_USE_ONLYCaptionLbl: label 'FOR OFFICIAL USE ONLY';
        CONDITIONSCaptionLbl: label 'CONDITIONS';
        INSTRUCTIONSCaptionLbl: label 'INSTRUCTIONS';
        V2_Quote_on_each_item_separately__and_in_units_as_specified_CaptionLbl: label '2.Quote on each item separately, and in units as specified.';
        V3_This_form_must_be_signed_by_a_competent_person_and_preferably_it_should_be_rubber_stamped_CaptionLbl: label '3.This form must be signed by a competent person and preferably it should be rubber stamped.';

    procedure SetRportFilt(DocType: Option "Quotation Request","Open Tender","Restricted Tender"; "DocNo.": Code[20])
    begin
        "Quotation Request Vendors".SetFilter("Document Type", Format(DocType));
        "Quotation Request Vendors".SetFilter("Requisition Document No.", "DocNo.");
    end;
}

