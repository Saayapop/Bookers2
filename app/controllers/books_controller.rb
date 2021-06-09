class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "successfully created."
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user
      render :index
    end

  end

  def index
    @books = Book.all
    @user = current_user
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @book_comments = @book.book_comments
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "successfully updated."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def correct_user
   @book = Book.find(params[:id])
   if @book.user != current_user
     redirect_to books_path
   end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
