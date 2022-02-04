//
//  DirectMessageListViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD

class DirectMessageListViewModel: ViewModelProtocol {
    
    struct Input {
        let getMember = PublishSubject<getMemberAction>()
        let refresh = PublishSubject<Void>()
        let itemSelected = PublishRelay<Int>()
    }
    
    struct Output {
        let memberListCellData = PublishSubject<[UserModel]>()
        let refreshLoading = PublishRelay<Bool>()
        let goToMessage = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    var cellData: Driver<[UserModel]>
    let push: Driver<(MessageViewModel, Int)>
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        let messageViewModel = MessageViewModel()
        
        self.cellData = output.memberListCellData
            .asDriver(onErrorJustReturn: [])
        
        //MARK: - push
        self.push = input.itemSelected
            .compactMap { row -> (MessageViewModel, Int) in
                return (messageViewModel, row)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // refresh
        input.refresh.withLatestFrom(input.getMember)
            .bind { [weak self] (member) in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspace(method: .get, member.accessToken, member.workspaceId)
                    self.output.refreshLoading.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // init - Cell Data
        input.getMember.withLatestFrom(input.getMember)
            .bind { [weak self] (member) in
                guard let self = self else { return }
                self.getWorkspace(method: .get, member.accessToken, member.workspaceId)
            }.disposed(by: disposeBag)
    }
    
    func getWorkspace(method: HTTPMethod, _ token:String, _ workspaceId: String) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(method: method, accessToken: token, workspaceId: workspaceId, isMembers: true )
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let decodedData):
                            guard let members = decodedData.data?.members?.content else {
                                self.output.errorMessage.accept("워크스페이스를 찾지 못했습니다")
                                return
                            }
                            self.output.memberListCellData.onNext(self.convertData(members: members))
                        default:
                            self.output.errorMessage.accept("일시적인 문제가 발생했습니다")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func convertData(members: [WorkspaceMemberCellModel]) -> [UserModel] {
        var userList = [UserModel]()
        
        for member in members {
            let user = UserModel(
                senderId: member.id.description,
                displayName: member.displayname ?? "이름 없음",
                name: member.name,
                email: member.email,
                description: member.description,
                phone: member.phone,
                country: member.country,
                language: member.language,
                settings: member.settings,
                status: member.status,
                createDt: member.createDt,
                modifyDt: member.modifyDt
            )
            userList.append(user)
        }
        return userList
    }
}
