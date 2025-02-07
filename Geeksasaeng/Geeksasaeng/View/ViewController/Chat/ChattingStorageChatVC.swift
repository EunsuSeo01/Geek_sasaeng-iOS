////
////  ChattingStorageChatVC.swift
////  Geeksasaeng
////
////  Created by 조동진 on 2022/10/13.
////
//
//import UIKit
//
//import Kingfisher
//import RMQClient
//import SnapKit
//import Then
//
//// Delegate Pattern을 통해 pushVC 구현
////protocol PushReportUserDelegate {
////    func pushReportUserVC()
////}
//
//class ChattingStorageChatViewController: UIViewController {
//    
//    // MARK: - SubViews
//    
//    /* 채팅 시작 날짜, 참여자 프로필 사진 */
//    let dateLabel = UILabel().then {
//        $0.text = "2022.08.08" // dummy date
//        $0.font = .customFont(.neoMedium, size: 15)
//    }
//    let participantProfileImageStackView = UIStackView().then { stackView in
//        stackView.axis = .horizontal
//        stackView.sizeToFit()
//        stackView.layoutIfNeeded()
//        stackView.distribution = .fillProportionally
//        stackView.alignment = .leading
//        stackView.spacing = -5
//        
//        let dummyImages = [UIImageView(image: UIImage(named: "DefaultProfile")),
//                           UIImageView(image: UIImage(named: "DefaultProfile")),
//                           UIImageView(image: UIImage(named: "DefaultProfile")),
//                           UIImageView(image: UIImage(named: "DefaultProfile")),
//                           UIImageView(image: UIImage(named: "DefaultProfile")),
//                           UIImageView(image: UIImage(named: "DefaultProfile"))]
//        
//        for dummyImage in dummyImages {
//            dummyImage.snp.makeConstraints { make in
//                make.width.height.equalTo(17)
//            }
//            
//            stackView.addArrangedSubview(dummyImage)
//        }
//    }
//    
//    /* collectionView 생성할 때, Layout 초기화 필요 -> then 쓰기 위해 바깥에 layout 변수 선언 */
//    let layout = UICollectionViewFlowLayout().then {
//        $0.minimumLineSpacing = 9
//    }
//    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
//        $0.backgroundColor = .white
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
//        $0.addGestureRecognizer(gesture)
//    }
//    
//    /* bottomView components */
//    let bottomView = UIView().then {
//        $0.backgroundColor = .init(hex: 0xEFEFEF)
//    }
//    let sendImageButton = UIButton().then {
//        $0.setImage(UIImage(named: "SendImage"), for: .normal)
//    }
//    let contentsTextView = UITextView().then {
//        $0.font = .customFont(.neoMedium, size: 16)
//        $0.backgroundColor = .init(hex: 0xEFEFEF)
//        $0.textColor = .black
//        $0.textAlignment = .left
//        $0.isEditable = true
//        $0.text = "본 채팅방은 비활성화되었습니다"
//        $0.textColor = .init(hex: 0xD8D8D8)
//    }
//    lazy var sendButton = UIButton().then {
//        $0.setTitle("전송", for: .normal)
//        $0.titleLabel?.font = .customFont(.neoMedium, size: 16)
//        $0.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
//        $0.isEnabled = false
//    }
//    
//    
//    // 방장에게 띄워질 액션 시트
//    lazy var ownerAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then { actionSheet in
//        [
//            UIAlertAction(title: "배달 완료 알림 보내기", style: .default, handler: { _ in self.tapDeliveryConfirmButton() }),
//            UIAlertAction(title: "매칭 마감하기", style: .default, handler: { _ in self.tapCloseMatchingButton() }),
//            UIAlertAction(title: "강제 퇴장시키기", style: .default, handler: { _ in self.tapForcedExitButton() }),
//            UIAlertAction(title: "채팅 나가기", style: .default, handler: { _ in self.tapEndOfChatButton() }),
//            UIAlertAction(title: "닫기", style: .cancel)
//        ].forEach{ actionSheet.addAction($0) }
//    }
//    
//    // 방장이 아닌 유저에게 띄워질 액션 시트
//    lazy var userAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then { actionSheet in
//        // alert 발생 시 나타날 액션선언 및 추가
//        [
//            UIAlertAction(title: "채팅 나가기", style: .default, handler: { _ in self.tapEndOfChatButton() }),
//            UIAlertAction(title: "닫기", style: .cancel)
//        ].forEach{ actionSheet.addAction($0) }
//    }
//    
//    // 나가기 뷰
//    lazy var exitView = UIView().then { view in
//        view.backgroundColor = .white
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 7
//        
//        /* top View: 삭제하기 */
//        let topSubView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
//        }
//        view.addSubview(topSubView)
//        topSubView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        
//        /* set titleLabel */
//        let titleLabel = UILabel().then {
//            $0.text = "나가기"
//            $0.textColor = UIColor(hex: 0xA8A8A8)
//            $0.font = .customFont(.neoMedium, size: 14)
//        }
//        topSubView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        /* set cancelButton */
//        lazy var cancelButton = UIButton().then {
//            $0.setImage(UIImage(named: "Xmark"), for: .normal)
//            $0.addTarget(self, action: #selector(self.tapXButton), for: .touchUpInside)
//        }
//        topSubView.addSubview(cancelButton)
//        cancelButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.width.equalTo(20)
//            make.height.equalTo(12)
//            make.right.equalToSuperview().offset(-15)
//        }
//        
//        /* bottom View: contents, 확인 버튼 */
//        let bottomSubView = UIView().then {
//            $0.backgroundColor = UIColor.white
//        }
//        view.addSubview(bottomSubView)
//        bottomSubView.snp.makeConstraints { make in
//            make.top.equalTo(topSubView.snp.bottom)
//            make.width.equalToSuperview()
//            make.height.equalTo(162)
//        }
//        
//        let contentLabel = UILabel().then {
//            $0.text = "본 채팅방을 나갈 시\n이후로 채팅에 참여할 수\n없습니다. 계속하시겠습니까?"
//            $0.numberOfLines = 0
//            $0.textColor = .init(hex: 0x2F2F2F)
//            $0.font = .customFont(.neoMedium, size: 14)
//            let attrString = NSMutableAttributedString(string: $0.text!)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 6
//            paragraphStyle.alignment = .center
//            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//            $0.attributedText = attrString
//        }
//        let lineView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
//        }
//        lazy var confirmButton = UIButton().then {
//            $0.setTitleColor(.mainColor, for: .normal)
//            $0.setTitle("확인", for: .normal)
//            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
//            $0.addTarget(self, action: #selector(self.tapExitConfirmButton), for: .touchUpInside)
//        }
//        
//        [contentLabel, lineView, confirmButton].forEach {
//            bottomSubView.addSubview($0)
//        }
//        contentLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(25)
//        }
//        lineView.snp.makeConstraints { make in
//            make.top.equalTo(contentLabel.snp.bottom).offset(25)
//            make.left.equalTo(18)
//            make.right.equalTo(-18)
//            make.height.equalTo(1.7)
//        }
//        confirmButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(lineView.snp.bottom).offset(18)
//            make.width.height.equalTo(34)
//        }
//    }
//    
//    /* 매칭 마감하기 누르면 나오는 매칭마감 안내 뷰 */
//    lazy var closeMatchingView = UIView().then { view in
//        view.backgroundColor = .white
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 7
//        view.snp.makeConstraints { make in
//            make.width.equalTo(256)
//            make.height.equalTo(250)
//        }
//        
//        /* top View */
//        let topSubView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
//        }
//        view.addSubview(topSubView)
//        topSubView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        
//        /* set titleLabel */
//        let titleLabel = UILabel().then {
//            $0.text = "매칭 마감하기"
//            $0.textColor = UIColor(hex: 0xA8A8A8)
//            $0.font = .customFont(.neoMedium, size: 14)
//        }
//        topSubView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        /* set cancelButton */
//        lazy var cancelButton = UIButton().then {
//            $0.setImage(UIImage(named: "Xmark"), for: .normal)
//            $0.addTarget(self, action: #selector(self.removeCloseMatchingView), for: .touchUpInside)
//        }
//        topSubView.addSubview(cancelButton)
//        cancelButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.width.equalTo(20)
//            make.height.equalTo(12)
//            make.right.equalToSuperview().offset(-15)
//        }
//        
//        /* bottom View: contents, 확인 버튼 */
//        let bottomSubView = UIView().then {
//            $0.backgroundColor = UIColor.white
//        }
//        view.addSubview(bottomSubView)
//        bottomSubView.snp.makeConstraints { make in
//            make.top.equalTo(topSubView.snp.bottom)
//            make.width.equalToSuperview()
//            make.height.equalTo(200)
//        }
//        
//        let contentLabel = UILabel().then {
//            $0.text = "매칭을 종료할 시\n본 파티에 대한 추가 인원이\n더 이상 모집되지 않습니다.\n계속하시겠습니까?"
//            $0.numberOfLines = 0
//            $0.textColor = .init(hex: 0x2F2F2F)
//            $0.font = .customFont(.neoMedium, size: 14)
//            let attrString = NSMutableAttributedString(string: $0.text!)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 6
//            paragraphStyle.alignment = .center
//            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//            $0.attributedText = attrString
//        }
//        let lineView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
//        }
//        lazy var confirmButton = UIButton().then {
//            $0.setTitleColor(.mainColor, for: .normal)
//            $0.setTitle("확인", for: .normal)
//            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
//            $0.addTarget(self, action: #selector(self.tapConfirmButton), for: .touchUpInside)
//        }
//        
//        [contentLabel, lineView, confirmButton].forEach {
//            bottomSubView.addSubview($0)
//        }
//        contentLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(20)
//        }
//        lineView.snp.makeConstraints { make in
//            make.top.equalTo(contentLabel.snp.bottom).offset(15)
//            make.left.equalTo(18)
//            make.right.equalTo(-18)
//            make.height.equalTo(1.7)
//        }
//        confirmButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(lineView.snp.bottom).offset(18)
//            make.width.height.equalTo(34)
//        }
//    }
//    
//    // 송금하기 상단 뷰 (Firestore의 participant의 isRemittance 값이 false인 경우에만 노출)
//    lazy var remittanceView = UIView().then { view in
//        view.backgroundColor = .init(hex: 0xF6F9FB)
//        view.layer.opacity = 0.9
//        
//        let coinImageView = UIImageView().then {
//            $0.image = UIImage(named: "RemittanceIcon")
//        }
//        
//        let accountLabel = UILabel().then {
//            $0.font = .customFont(.neoMedium, size: 14)
//            $0.textColor = .init(hex: 0x2F2F2F)
//            $0.text = "\(self.bank ?? "은행")  \(self.accountNumber ?? "000-0000-0000-00")"
//        }
//        
//        let remittanceConfirmButton = UIButton().then {
//            $0.setTitle("송금 완료", for: .normal)
//            $0.titleLabel?.font = .customFont(.neoMedium, size: 11)
//            $0.titleLabel?.textColor = .white
//            $0.backgroundColor = .mainColor
//            $0.layer.cornerRadius = 5
//            $0.addTarget(self, action: #selector(tapRemittanceButton), for: .touchUpInside)
//        }
//        
//        [coinImageView, accountLabel, remittanceConfirmButton].forEach {
//            view.addSubview($0)
//        }
//        coinImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(29)
//            make.width.height.equalTo(24)
//        }
//        accountLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(coinImageView.snp.right).offset(8)
//        }
//        remittanceConfirmButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().inset(28)
//            make.width.equalTo(67)
//            make.height.equalTo(29)
//        }
//    }
//    
//    // 주문완료 상단 뷰 (방장인 경우에만 노출)
//    lazy var orderCompletedView = UIView().then { view in
//        view.backgroundColor = .init(hex: 0xF6F9FB)
//        view.layer.opacity = 0.9
//        
//        let orderCompletedImageView = UIImageView().then {
//            $0.image = UIImage(named: "OrderCompletedIcon")
//        }
//        
//        let showMenuLabel = UILabel().then {
//            $0.font = .customFont(.neoMedium, size: 14)
//            $0.textColor = .init(hex: 0x2F2F2F)
//            $0.text = "메뉴판 보기"
//        }
//        
//        let orderCompletedButton = UIButton().then {
//            $0.setTitle("주문 완료", for: .normal)
//            $0.titleLabel?.font = .customFont(.neoMedium, size: 11)
//            $0.titleLabel?.textColor = .white
//            $0.backgroundColor = .mainColor
//            $0.layer.cornerRadius = 5
//        }
//        
//        [orderCompletedImageView, showMenuLabel, orderCompletedButton].forEach {
//            view.addSubview($0)
//        }
//        orderCompletedImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(29)
//            make.width.height.equalTo(24)
//        }
//        showMenuLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(orderCompletedImageView.snp.right).offset(8)
//        }
//        orderCompletedButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().inset(28)
//            make.width.equalTo(67)
//            make.height.equalTo(29)
//        }
//    }
//    
//    // 배달완료 알림 보내기 재확인 알림뷰
//    lazy var notificationSendView = UIView().then {
//        $0.backgroundColor = .white
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 7
//        $0.snp.makeConstraints { make in
//            make.width.equalTo(256)
//            make.height.equalTo(226)
//        }
//        
//        /* top View: 배달완료 알림 보내기 */
//        let topSubView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
//        }
//        $0.addSubview(topSubView)
//        topSubView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        
//        /* set titleLabel */
//        let titleLabel = UILabel().then {
//            $0.text = "배달완료 알림 보내기"
//            $0.textColor = UIColor(hex: 0xA8A8A8)
//            $0.font = .customFont(.neoMedium, size: 14)
//        }
//        topSubView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        /* set cancelButton */
//        lazy var cancelButton = UIButton().then {
//            $0.setImage(UIImage(named: "Xmark"), for: .normal)
//            $0.addTarget(self, action: #selector(self.removeNotificationSendView), for: .touchUpInside)
//        }
//        topSubView.addSubview(cancelButton)
//        cancelButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.width.equalTo(20)
//            make.height.equalTo(12)
//            make.right.equalToSuperview().offset(-15)
//        }
//        
//        /* bottom View: contents, 보내기 버튼 */
//        let bottomSubView = UIView().then {
//            $0.backgroundColor = UIColor.white
//        }
//        $0.addSubview(bottomSubView)
//        bottomSubView.snp.makeConstraints { make in
//            make.top.equalTo(topSubView.snp.bottom)
//            make.width.equalToSuperview()
//            make.height.equalTo(176)
//        }
//        
//        let contentLabel = UILabel().then {
//            $0.text = "주문한 음식이 배달되었는지\n다시 확인한 후 알림을\n보내보세요. "
//            $0.numberOfLines = 0
//            $0.textColor = .init(hex: 0x2F2F2F)
//            $0.font = .customFont(.neoMedium, size: 14)
//            let attrString = NSMutableAttributedString(string: $0.text!)
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 6
//            paragraphStyle.alignment = .center
//            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//            $0.attributedText = attrString
//        }
//        let lineView = UIView().then {
//            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
//        }
//        lazy var confirmButton = UIButton().then {
//            $0.setTitleColor(.mainColor, for: .normal)
//            $0.setTitle("보내기", for: .normal)
//            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
//            $0.addTarget(self, action: #selector(self.tapNotificationSendButton), for: .touchUpInside)
//        }
//        
//        [contentLabel, lineView, confirmButton].forEach {
//            bottomSubView.addSubview($0)
//        }
//        contentLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().inset(20)
//        }
//        lineView.snp.makeConstraints { make in
//            make.top.equalTo(contentLabel.snp.bottom).offset(15)
//            make.left.right.equalToSuperview().inset(18)
//            make.height.equalTo(1.7)
//        }
//        confirmButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(lineView.snp.bottom).offset(18)
//        }
//    }
//    
//    // 블러 뷰
//    var visualEffectView: UIVisualEffectView?
//    
//    // MARK: - Properties
//    
//    var contents: [cellContents] = []
//    var userNickname: String?
//    var maxMatching: Int?
//    var currentMatching: Int?
//    // 선택한 채팅방의 uuid값
//    var roomUUID: String?
//    var roomName: String?
//    
//    var firstRoomInfo = true
//    var firstMessage = true
//    
//    var lastSender: String?
//    
//    var roomMaster: String? // 내가 현재 방장인지
//    var bank: String?
//    var accountNumber: String?
//    var enterTimeToDate: Date?    // 내가 이 방에 들어온 시간
//    
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        contentsTextView.delegate = self
//        
//        setCollectionView()
//        addSubViews()
//        setLayouts()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationItem.title = roomName
//        
//        // 커스텀한 새 백버튼으로 구성
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back(sender:)))
//        navigationItem.leftBarButtonItem?.tintColor = .black
//        
//        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(tapOptionButton)), animated: true)
//        navigationItem.rightBarButtonItem?.tintColor = .init(hex: 0x2F2F2F)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//        // 사라질 때 다시 탭바 보이게 설정
//        self.tabBarController?.tabBar.isHidden = false
//    }
//    
//    
//    
//    // MARK: - Functions
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        collectionView.endEditing(true)
//    }
//    
//    private func setCollectionView() {
//        collectionView.register(SystemMessageCell.self, forCellWithReuseIdentifier: "SystemMessageCell")
//        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
//        collectionView.register(SameSenderMessageCell.self, forCellWithReuseIdentifier: "SameSenderMessageCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        
//        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
//    }
//    
//    private func addSubViews() {
//        [sendImageButton, contentsTextView, sendButton].forEach {
//            bottomView.addSubview($0)
//        }
//        
//        [dateLabel, participantProfileImageStackView, collectionView, bottomView].forEach {
//            view.addSubview($0)
//        }
//    }
//    
//    private func setLayouts() {
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(34)
//            make.centerX.equalToSuperview()
//        }
//        participantProfileImageStackView.snp.makeConstraints { make in
//            make.top.equalTo(dateLabel.snp.bottom).offset(14)
//            make.centerX.equalToSuperview()
//        }
//        
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(participantProfileImageStackView.snp.bottom).offset(48)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(bottomView.snp.top)
//        }
//        
//        bottomView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(69)
//        }
//        
//        sendImageButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(33)
//            make.left.equalToSuperview().inset(20)
//        }
//        
//        sendButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().inset(22)
//        }
//        
//        contentsTextView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(sendImageButton.snp.right).offset(13)
//            make.width.equalTo(230)
//            make.height.equalTo(40)
//        }
//    }
//    
//    // 배경을 흐리게, 블러뷰로 설정
//    private func showBlurBackground() {
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        visualEffectView.layer.opacity = 0.6
//        visualEffectView.frame = view.frame
//        visualEffectView.isUserInteractionEnabled = false
//        view.addSubview(visualEffectView)
//        self.visualEffectView = visualEffectView
//        
//        // 키보드가 올라와있는 상태면 내린다.
//        view.endEditing(true)
//    }
//    
//    /* 파라미터로 온 뷰와 배경 블러뷰 함께 제거 */
//    private func removeViewWithBlurView(_ view: UIView) {
//        view.removeFromSuperview()
//        visualEffectView?.removeFromSuperview()
//    }
//    
//    private func getMessageLabelHeight(text: String) -> CGFloat {
//        let label = PaddingLabel()
//        label.paddingLeft = 18
//        label.paddingRight = 18
//        label.paddingTop = 10
//        label.paddingBottom = 10
//        
//        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.569, height: CGFloat.greatestFiniteMagnitude)
//        
//        label.text = text
//        label.font = .customFont(.neoMedium, size: 15)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byCharWrapping
//        label.preferredMaxLayoutWidth = 200
//        label.sizeToFit()
//        label.setNeedsDisplay()
//        
//        return label.frame.height
//    }
//    
//    private func getSystemMessageLabelHeight(text: String) -> CGFloat {
//        let label = PaddingLabel()
//        label.paddingLeft = 18
//        label.paddingRight = 18
//        label.paddingTop = 6
//        label.paddingBottom = 6
//        
//        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.783, height: CGFloat.greatestFiniteMagnitude)
//        
//        label.text = text
//        label.font = .customFont(.neoMedium, size: 12)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byCharWrapping
//        label.preferredMaxLayoutWidth = 250
//        label.textAlignment = .center
//        label.sizeToFit()
//        label.setNeedsDisplay()
//        
//        return label.frame.height
//    }
//    
//    private func formatTime(str: String) -> String {
//        let startIdx = str.index(str.startIndex, offsetBy: 11)
//        let endIdx = str.index(startIdx, offsetBy: 5)
//        let range = startIdx..<endIdx
//        return String(str[range])
//    }
//    
//    // MARK: - @objc Functions
//    
//    /* 키보드가 올라올 때 실행되는 함수 */
//    @objc
//    private func keyboardWillShow(sender: NSNotification) {
//        // 1. 키보드의 높이를 구함
//        if let info = sender.userInfo,
//           let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
//            // 2. collectionView의 contentInset bottom 값을 변경하여 키보드 위로 content가 올라갈 수 있도록 함
//            collectionView.contentInset.bottom = keyboardHeight
//            // 3. 키보드 높이만큼 bottomView의 y값을 변경
//            bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
//            
//            // 4. 맨 마지막 아이템으로 스크롤을 해줌으로써 마지막 채팅이 키보드의 위에 뜨도록 함
//            self.collectionView.scrollToItem(at: IndexPath(row: self.contents.count-1, section: 0), at: .top, animated: true)
//        }
//    }
//
//    /* 키보드가 내려갈 때 실행되는 함수 */
//    @objc
//    private func keyboardWillHide(sender: NSNotification) {
//        // collectionView의 contentInset 값과 bottomView의 transform을 원래대로 변경
//        collectionView.contentInset.bottom = 0
//        bottomView.transform = .identity
//    }
//    
//    /* 왼쪽 상단 백버튼 클릭시 실행되는 함수 */
//    @objc
//    private func back(sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    /* 오른쪽 위의 톱니바퀴 버튼 클릭시 실행되는 함수 */
//    @objc
//    private func tapOptionButton() {
//        if roomMaster == LoginModel.nickname {
//            /* 방장인 경우의 액션 시트 띄우기 */
//            present(ownerAlertController, animated: true)
//        } else {
//            /* 방장이 아닌 유저일 경우의 액션 시트 띄우기 */
//            present(userAlertController, animated: true)
//        }
//    }
//    
//    /* 송금 완료 버튼 클릭 */
//    @objc
//    private func tapRemittanceButton() {
//        self.remittanceView.removeFromSuperview()
//    }
//    
//    /* 배경의 컬렉션뷰 클릭시 띄워져있는 안내뷰와 블러뷰를 없애는 함수 */
//    @objc
//    private func tapCollectionView() {
//        view.endEditing(true)
//        
//        if visualEffectView != nil { // nil이 아니라면, 즉 옵션뷰가 노출되어 있다면
//            view.subviews.forEach {
//                if $0 == exitView || $0 == closeMatchingView || $0 == notificationSendView {
//                    removeViewWithBlurView($0)
//                }
//            }
//        }
//    }
//    
//    /* 액션시트에서 배달 완료 알림 보내기 버튼 누르면 실행되는 함수 */
//    @objc
//    private func tapDeliveryConfirmButton() {
//        // 배경 블러뷰
//        showBlurBackground()
//        
//        // 배달완료 알림 보내기 알림뷰 등장
//        view.addSubview(notificationSendView)
//        notificationSendView.snp.makeConstraints { make in
//            make.center.equalTo(view.center)
//        }
//    }
//    
//    /* 배달완료 알림 전송 재확인 뷰에서 '보내기' 버튼 클릭시 실행되는 함수 */
//    @objc
//    private func tapNotificationSendButton() {
//        print("DEBUG: 클릭!!!")
//        // 알림뷰 제거
//        removeNotificationSendView()
//        
//        // 서버에 요청
//        let input = DeliveryNotificationInput(uuid: roomUUID)
//        DeliveryNotificationAPI.requestPushNotification(input) { [self] isSuccess in
//            // 토스트 메세지 띄우기
//            if isSuccess {
//                print("DEBUG: 성공!!!")
//                self.showToast(viewController: self, message: "배달완료 알림 전송이 완료되었습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
//            } else {
//                print("DEBUG: 실패!!!")
//                self.showToast(viewController: self, message: "배달완료 알림 전송에 실패하였습니다", font: .customFont(.neoBold, size: 15), color: .mainColor, width: 287, height: 59)
//            }
//            
//        }
//    }
//    
//    /* 배달 완료 알림 전송 재확인 뷰에서 X자 눌렀을 때 실행되는 함수 */
//    @objc
//    private func removeNotificationSendView() {
//        removeViewWithBlurView(notificationSendView)
//    }
//    
//    /* 매칭 마감하기 버튼 누르면 실행되는 함수 */
//    @objc
//    private func tapCloseMatchingButton() {
//        // 배경 블러뷰
//        showBlurBackground()
//        
//        /* 매칭 마감 뷰 보여줌 */
//        view.addSubview(closeMatchingView)
//        closeMatchingView.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
//    }
//    
//    /* 매칭 마감하기 뷰에서 X자 눌렀을 때 실행되는 함수 */
//    @objc
//    private func removeCloseMatchingView() {
//        removeViewWithBlurView(closeMatchingView)
//    }
//    
//    /* 매칭 마감하기 뷰에서 확인 눌렀을 때 실행되는 함수 */
//    @objc
//    private func tapConfirmButton() {
//        let input = CloseMatchingInput(uuid: roomUUID)
//        CloseMatchingAPI.requestCloseMatching(input) { isSuccess in
//            if isSuccess {
//                // 매칭 마감 버튼 비활성화
//                self.ownerAlertController.actions[1].isEnabled = false
//                self.ownerAlertController.actions[1].setValue(UIColor.init(hex: 0xA8A8A8), forKey: "titleTextColor")
//            }
//        }
//        
//        // 매칭 마감하기 뷰 없애기
//        removeCloseMatchingView()
//    }
//    
//    // 강제 퇴장시키기 버튼 누르면 실행되는 함수
//    @objc
//    private func tapForcedExitButton() {
//        let forcedExitVC = ForcedExitViewController()
//        navigationController?.pushViewController(forcedExitVC, animated: true)
//    }
//    
//    /* 채팅 나가기 버튼 클릭시 실행 -> 재확인 뷰 띄워줌 */
//    @objc
//    private func tapEndOfChatButton() {
//        // 배경 블러뷰
//        showBlurBackground()
//        
//        // exitView 추가
//        view.addSubview(exitView)
//        exitView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(256)
//            make.height.equalTo(236)
//        }
//    }
//    
//    /* 채팅 나가기에서 'X' 버튼 클릭시 실행 */
//    @objc
//    private func tapXButton() {
//        removeViewWithBlurView(exitView)
//    }
//    
//    /* 채팅 나가기에서 '확인' 버튼 클릭시 실행 */
//    @objc
//    private func tapExitConfirmButton() {
//        guard let roomUUID = roomUUID else { return }
//        
//        // 본인이 방장일 때
//        if roomMaster == LoginModel.nickname {
//            // 서버에 알려줘서 서버의 방장도 바꿔줌
//            let input = ChatRoomExitForCheifInput(nickName: roomMaster, uuid: roomUUID)
//            ChatRoomExitAPI.patchExitCheif(input)
//        } else { // 본인이 방장이 아닐 때
//            // 서버에 나간 사람 알려줌
//            let input = ChatRoomExitInput(uuid: roomUUID)
//            ChatRoomExitAPI.patchExitUser(input)
//        }
////        if var currentMatching = currentMatching {
////            currentMatching -= 1
////        }
//        navigationController?.popViewController(animated: true)
//    }
//    
//    /* 채팅방에 있는 상대 유저 프로필 클릭시 실행되는 함수 */
//    @objc
//    private func tapProfileImage() {
//        let popUpView = ProfilePopUpViewController()
//        popUpView.delegate = self
//        popUpView.modalPresentationStyle = .overFullScreen
//        popUpView.modalTransitionStyle = .crossDissolve
//        self.present(popUpView, animated: true)
//    }
//}
//
//// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//
//extension ChattingStorageChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return contents.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
////        switch contents[indexPath.row].cellType {
////        case .systemMessage: // 시스템 메세지
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
////            cell.systemMessageLabel.text = contents[indexPath.row].message?.content
////            print("Seori Test: sys #\(indexPath.item)", cell)
////            return cell
////        case .sameSenderMessage: // 같은 사람이 연속 전송
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SameSenderMessageCell", for: indexPath) as! SameSenderMessageCell
////            if contents[indexPath.row].message?.nickname == LoginModel.nickname { // 보낸 사람이 자신
////                cell.rightMessageLabel.text = contents[indexPath.row].message?.content
////                cell.rightTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
////                cell.leftTimeLabel.isHidden = true
////                cell.leftMessageLabel.isHidden = true
////            } else {
////                cell.leftMessageLabel.text = contents[indexPath.row].message?.content
////                cell.leftTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
////                cell.rightTimeLabel.isHidden = true
////                cell.rightMessageLabel.isHidden = true
////            }
////            print("Seori Test: same #\(indexPath.item)", cell)
////            return cell
////        default: // 다른 사람이 전송
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
////            cell.nicknameLabel.text = contents[indexPath.row].message?.nickname
////            if contents[indexPath.row].message?.nickname == LoginModel.nickname { // 보낸 사람이 자신이면
////                cell.rightMessageLabel.text = contents[indexPath.row].message?.content
////                cell.nicknameLabel.textAlignment = .right
////                cell.rightTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
////                cell.leftTimeLabel.isHidden = true
////                cell.leftMessageLabel.isHidden = true
////                cell.leftImageView.isHidden = true
////                if self.roomMaster == contents[indexPath.row].message?.nickname { // 방장이라면
////                    cell.rightImageView.image = UIImage(named: "RoomMasterProfile")
////                } else {// 방장이 아니면 기본 프로필로 설정
////                    cell.rightImageView.image = UIImage(named: "DefaultProfile")
////                }
////
////                print("Seori Test: me #\(indexPath.item)", cell)
////            } else {
////                cell.leftImageView.isUserInteractionEnabled = true
////                cell.leftImageView.addTarget(self, action: #selector(tapProfileImage), for: .touchUpInside)
////                cell.leftMessageLabel.text = contents[indexPath.row].message?.content
////                cell.nicknameLabel.textAlignment = .left
////                cell.leftTimeLabel.text = formatTime(str: (contents[indexPath.row].message?.time)!)
////                cell.rightTimeLabel.isHidden = true
////                cell.rightMessageLabel.isHidden = true
////                cell.rightImageView.isHidden = true
////                if self.roomMaster == contents[indexPath.row].message?.nickname { // 방장이라면
////                    cell.leftImageView.setImage(UIImage(named: "RoomMasterProfile"), for: .normal)
////                } else {// 방장이 아니면 기본 프로필로 설정
////                    cell.leftImageView.setImage(UIImage(named: "DefaultProfile"), for: .normal)
////                }
////
////                print("Seori Test: other #\(indexPath.item)", cell)
////            }
////            return cell
////        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize: CGSize
//
//        switch contents[indexPath.row].cellType {
//        case .systemMessage:
//            let labelHeight = getSystemMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
//            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // padding top, bottom = 6
//        case .message:
//            // content의 크기에 맞는 라벨을 정의하고 해당 라벨의 높이가 40 초과 (두 줄 이상) or 40 (한 줄) 비교하여 높이 적용
//            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
//            cellSize = CGSize(width: view.bounds.width, height: labelHeight + 16) // 상하 여백 20 + 닉네임 라벨
//        case .sameSenderMessage:
//            let labelHeight = getMessageLabelHeight(text: contents[indexPath.row].message?.content ?? "")
//            cellSize = CGSize(width: view.bounds.width, height: labelHeight) // label 상하 여백 20
//        default:
//            cellSize = CGSize(width: view.bounds.width, height: 40)
//        }
//        
//        return cellSize
//    }
//    
//}
//
//// MARK: - UITextViewDelegate
//
//extension ChattingStorageChatViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.count > 0 {
//            sendButton.isEnabled = true
//            sendButton.setTitleColor(.mainColor, for: .normal)
//        } else {
//            sendButton.isEnabled = false
//            sendButton.setTitleColor(UIColor(hex: 0xD8D8D8), for: .normal)
//        }
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "입력하세요" {
//            textView.text = nil
//            textView.textColor = .black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            textView.text = "입력하세요"
//            textView.textColor = UIColor(hex: 0xD8D8D8)
//        }
//    }
//}
//
//// MARK: - PushReportUserDelegate
//
//extension ChattingStorageChatViewController: PushReportUserDelegate {
//    public func pushReportUserVC() {
//        let reportUserVC = ReportUserViewController()
//        self.navigationController?.pushViewController(reportUserVC, animated: true)
//    }
//}
