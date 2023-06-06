//
//  RecipeDetailViewController.swift
//  IceButler_iOS
//
//  Created by 김나연 on 2023/05/22.
//

import UIKit

class RecipeDetailViewController: BaseViewController {
    
    private var recipeIdx: Int!
    private var indexPath: IndexPath!
    private var recipeType: RecipeType!
    private var isFromMyRecipe: Bool = false
    private var recipeDetail: RecipeDetailResponseModel!
    @IBOutlet var naviItem: UINavigationItem!
    @IBOutlet var representativeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountView: UIView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var timeRequiredView: UIView!
    @IBOutlet var timeRequiredLabel: UILabel!
    @IBOutlet var ingredientCollectionView: UICollectionView!
    @IBOutlet var cookingProcessTableView: UITableView!
    private var ingredientTextList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchData() {
        RecipeViewModel.shared.getRecipeDetail(recipeIdx: recipeIdx) { response in
            // 삭제된 레시피 클릭 시 존재하지 않는 레시피 예외처리
            if response?.statusCode == 404 {
                let alert = UIAlertController(title: "존재하지 않는 레시피", message: "삭제되었거나 존재하지 않는 레시피입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                if let data = response?.data {
                    // 정상 처리
                    self.recipeDetail = data
                    self.ingredientTextList.removeAll()
                    data.recipeFoods.forEach { ingredient in
                        self.ingredientTextList.append(ingredient.foodName + " " + ingredient.foodDetail)
                    }
                    self.ingredientCollectionView.reloadData()
                    self.cookingProcessTableView.reloadData()
                    self.setupLayout()
                }
            }
        }
    }
    
    private func setup() {
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self
        cookingProcessTableView.delegate = self
        cookingProcessTableView.dataSource = self
        cookingProcessTableView.rowHeight = UITableView.automaticDimension
        
        let recipeIngredientCell = UINib(nibName: "RecipeDetailIngredientCell", bundle: nil)
        ingredientCollectionView.register(recipeIngredientCell, forCellWithReuseIdentifier: "RecipeDetailIngredientCell")
        let cookingProcessCell = UINib(nibName: "RecipeDetailCookingProcessCell", bundle: nil)
        cookingProcessTableView.register(cookingProcessCell, forCellReuseIdentifier: "RecipeDetailCookingProcessCell")
    }
    
    private func setupLayout() {
        if !isFromMyRecipe {
            // 즐겨찾기
            if recipeDetail.isSubscribe {
                self.setLikeStatus(isTrue: true)
            } else {
                self.setLikeStatus(isTrue: false)
            }
        }
        // 대표사진
        if let url = URL(string: recipeDetail.recipeImgUrl) {
            representativeImageView.kf.setImage(with: url)
            representativeImageView.contentMode = .scaleAspectFill
        }
        // 레시피명
        recipeNameLabel.text = recipeDetail.recipeName
        // 카테고리, 분량, 소요시간
        categoryLabel.text = recipeDetail.recipeCategory
        categoryView.layer.cornerRadius = categoryView.frame.height / 2
        categoryView.layer.masksToBounds = true
        amountLabel.text = "\(recipeDetail.quantity)인분"
        amountView.layer.cornerRadius = categoryView.frame.height / 2
        amountView.layer.masksToBounds = true
        timeRequiredLabel.text = "\(recipeDetail.leadTime)분"
        timeRequiredView.layer.cornerRadius = categoryView.frame.height / 2
        timeRequiredView.layer.masksToBounds = true
        // 재료
        ingredientCollectionView.collectionViewLayout = RecipeCollectionViewLeftAlignFlowLayout()
        if let flowLayout = ingredientCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        // 조리과정
        cookingProcessTableView.separatorStyle = .none
    }
    
    func configure(recipeIdx: Int, indexPath: IndexPath, recipeType: RecipeType, isFromMyRecipe: Bool? = nil) {
        self.recipeIdx = recipeIdx
        self.indexPath = indexPath
        self.recipeType = recipeType
        if let isFromMyRecipe = isFromMyRecipe {
            self.isFromMyRecipe = isFromMyRecipe
        }
    }
    
    private func setupNavigationBar() {
        self.tabBarController?.tabBar.isHidden = true
        // pop up menu
        if isFromMyRecipe {
            var menuItems: [UIAction] {
                return [
                    UIAction(title: "레시피 수정", image: UIImage(named: "pencil"), handler: { _ in
                        guard let addRecipeViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddRecipeViewController") as? AddRecipeViewController else { return }
                        addRecipeViewController.configure(recipeIdx: self.recipeIdx, indexPath: self.indexPath, isEditMode: self.isFromMyRecipe, recipeDetail: self.recipeDetail)
                        self.navigationController?.pushViewController(addRecipeViewController, animated: true)
                    }),
                    UIAction(title: "레시피 삭제", image: UIImage(named: "trash"), attributes: .destructive, handler: { _ in
                        let alertStoryboard = UIStoryboard.init(name: "Alert", bundle: nil)
                        guard let alertViewController = alertStoryboard.instantiateViewController(withIdentifier: "AlertViewController")as? AlertViewController else { return }
                        alertViewController.configure(title: "마이레시피 삭제", content: "해당 레시피를 삭제하시겠습니까?", leftButtonTitle: "취소", righttButtonTitle: "삭제", rightCompletion: {
                            self.showLoading()
                            RecipeViewModel.shared.deleteRecipe(recipeIdx: self.recipeIdx) { isSuccess in
                                self.hideLoading()
                                if isSuccess {
                                    let alert = UIAlertController(title: "레시피 삭제 성공", message: "레시피 삭제가 정상적으로 처리되었습니다.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                                        self.dismiss(animated: true)
                                    }))
                                    self.present(alert, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "레시피 삭제 실패", message: "레시피 삭제에 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                }}
                        }, leftCompletion: {})
                        alertViewController.modalPresentationStyle = .overFullScreen
                        alertViewController.modalTransitionStyle = .crossDissolve
                        self.present(alertViewController, animated: true)
                    })
                ]
            }
            var menu: UIMenu {
                return UIMenu(title: "", options: [], children: menuItems)
            }
            naviItem.rightBarButtonItems?.first?.menu = menu
        } else {
            var menuItems: [UIAction] {
                return [
                    UIAction(title: "신고", image: UIImage(named: "redReportIcon"), attributes: .destructive, handler: { _ in
                        let actionSheet = UIAlertController(title: "신고 사유 선택\n(부적절한 신고는 처리되지 않습니다.)", message: nil, preferredStyle: .actionSheet)
                        let promotionStr = "홍보/도배"
                        let obsceneMaterialStr = "음란물/유해한 정보"
                        let poorContentStr = "내용이 부실함"
                        let unsuitableStr = "게시글 성격에 부적합함"
                        [
                          UIAlertAction(title: promotionStr, style: .destructive, handler: { _ in
                              self.showLoading()
                              RecipeViewModel.shared.reportRecipe(recipeIdx: self.recipeIdx, reason: promotionStr) { isSuccess in
                                  self.showReportResultAlert(isSuccess)
                              }
                          }),
                          UIAlertAction(title: obsceneMaterialStr, style: .destructive, handler: { _ in
                              RecipeViewModel.shared.reportRecipe(recipeIdx: self.recipeIdx, reason: obsceneMaterialStr) { isSuccess in
                                  self.showReportResultAlert(isSuccess)
                              }
                          }),
                          UIAlertAction(title: poorContentStr, style: .destructive, handler: { _ in
                              RecipeViewModel.shared.reportRecipe(recipeIdx: self.recipeIdx, reason: poorContentStr) { isSuccess in
                                  self.showReportResultAlert(isSuccess)
                              }
                          }),
                          UIAlertAction(title: unsuitableStr, style: .destructive, handler: { _ in
                              RecipeViewModel.shared.reportRecipe(recipeIdx: self.recipeIdx, reason: unsuitableStr) { isSuccess in
                                  self.showReportResultAlert(isSuccess)
                              }
                          }),
                          UIAlertAction(title: "취소", style: .cancel)
                        ].forEach{ actionSheet.addAction($0) }

                        self.present(actionSheet, animated: true)
                    })
                ]
            }
            var menu: UIMenu {
                return UIMenu(title: "", options: [], children: menuItems)
            }
            naviItem.rightBarButtonItems?.first?.menu = menu
        }
    }
    
    func showReportResultAlert(_ isSuccess: Bool) {
        self.hideLoading()
        if isSuccess {
            let alert = UIAlertController(title: "레시피 신고 완료", message: "신고가 정상적으로 처리되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "레시피 신고 실패", message: "레시피 신고에 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func didTapXButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapBookmarkButton(_ sender: Any) {
        RecipeViewModel.shared.updateBookmarkStatus(recipeIdx: recipeIdx) { bookmarkStatus in
            RecipeViewModel.shared.needToReloadCell(recipeIdx: self.recipeIdx, indexPath: self.indexPath, recipeType: self.recipeType)
            self.setLikeStatus(isTrue: bookmarkStatus)
        }
    }
    
    private func setLikeStatus(isTrue: Bool) {
        if naviItem.rightBarButtonItems?.count == 2 {
            naviItem.rightBarButtonItems?.removeLast()
        }
        if isTrue {
            naviItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(named: "filledStar"), style: .plain, target: self, action: #selector(didTapBookmarkButton)))
        } else {
            naviItem.rightBarButtonItems?.append(UIBarButtonItem(image: UIImage(named: "emptyBlackStar"), style: .plain, target: self, action: #selector(didTapBookmarkButton)))
        }
    }
}

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientTextList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeDetailIngredientCell", for: indexPath) as! RecipeDetailIngredientCell
        cell.setIngredient(ingredientText: ingredientTextList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ingredientTextList[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 10, height: 22)
    }
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numOfCookeryStep = recipeDetail?.cookery.count {
            return numOfCookeryStep
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCookingProcessCell", for: indexPath) as? RecipeDetailCookingProcessCell else {return UITableViewCell()}
        let cookery = recipeDetail.cookery[indexPath.row]
        cell.configure(stepNum: cookery.nextIdx + 1, description: cookery.description, cookeryImgUrl: cookery.cookeryImgUrl)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}

class IntrinsicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        self.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
}
